package com.betopia.hrm.services.leaves.leavebalanceemployee.impl;

import com.betopia.hrm.domain.employee.entity.Employee;
import com.betopia.hrm.domain.employee.exception.employee.EmployeeNotFound;
import com.betopia.hrm.domain.employee.repository.EmployeeRepository;
import com.betopia.hrm.domain.leave.entity.LeaveBalanceEmployee;
import com.betopia.hrm.domain.leave.entity.LeaveGroupAssign;
import com.betopia.hrm.domain.leave.entity.LeavePolicy;
import com.betopia.hrm.domain.leave.entity.LeaveRequest;
import com.betopia.hrm.domain.leave.entity.LeaveType;
import com.betopia.hrm.domain.leave.exception.leaveGroupAssign.LeaveGroupAssignNotFoundException;
import com.betopia.hrm.domain.leave.exception.leavebalanceemployee.LeaveBalanceEmployeeNotFoundException;
import com.betopia.hrm.domain.leave.exception.leavepolicy.LeavePolicyNotFoundException;
import com.betopia.hrm.domain.leave.exception.leavepolicy.ValidationException;
import com.betopia.hrm.domain.leave.exception.leavetype.LeaveTypeNotFoundException;
import com.betopia.hrm.domain.leave.repository.LeaveBalanceEmployeeRepository;
import com.betopia.hrm.domain.leave.repository.LeaveGroupAssignRepository;
import com.betopia.hrm.domain.leave.repository.LeavePolicyRepository;
import com.betopia.hrm.domain.leave.repository.LeaveRequestRepository;
import com.betopia.hrm.domain.leave.repository.LeaveTypeRepository;
import com.betopia.hrm.services.leaves.leaveGroupAssign.LeaveGroupAssignService;
import com.betopia.hrm.services.leaves.leavebalanceemployee.LeaveBalanceEmployeeService;
import com.betopia.hrm.services.leaves.leavepolicy.leaverule.engine.LeaveRuleEngine;
import com.betopia.hrm.services.leaves.leavepolicy.leaverule.engine.ValidationResult;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class LeaveBalanceEmployeeImpl implements LeaveBalanceEmployeeService {

    private final LeaveBalanceEmployeeRepository balanceRepository;
    private final LeavePolicyRepository policyRepository;
    private final LeaveTypeRepository leaveTypeRepository;
    private final EmployeeRepository employeeRepository;
    private final LeaveRuleEngine leaveRuleEngine;
    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveGroupAssignService leaveGroupAssignService;

    public LeaveBalanceEmployeeImpl(
            LeaveBalanceEmployeeRepository balanceRepository,
            LeavePolicyRepository policyRepository,
            LeaveTypeRepository leaveTypeRepository,
            EmployeeRepository employeeRepository,
            LeaveRuleEngine leaveRuleEngine,
            LeaveRequestRepository leaveRequestRepository,
            LeaveGroupAssignService leaveGroupAssignService
    ) {
        this.balanceRepository = balanceRepository;
        this.policyRepository = policyRepository;
        this.leaveTypeRepository = leaveTypeRepository;
        this.employeeRepository = employeeRepository;
        this.leaveRuleEngine = leaveRuleEngine;
        this.leaveRequestRepository = leaveRequestRepository;
        this.leaveGroupAssignService = leaveGroupAssignService;
    }

    // Fetch balances for employee
    @Override
    public List<LeaveBalanceEmployee> getBalancesForEmployee(Long employeeId, int year) {
        return balanceRepository.findByEmployeeIdAndYear(employeeId, year);
    }

    // Initialize leave balances for new year
    @Transactional
    @Override
    public void initializeYearlyBalances(Long employeeId, int year) {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EmployeeNotFound("Employee not found with id: " + employeeId));

        LeaveGroupAssign leaveGroupAssign = leaveGroupAssignService.findApplicableLeaveGroup(employee);

        List<LeavePolicy> allPolicies = policyRepository.findByLeaveGroupAssign(leaveGroupAssign);

        long tenureDays = ChronoUnit.DAYS.between(employee.getDateOfJoining(), LocalDate.now());
        Long employeeTypeId = employee.getEmployeeType().getId();

        List<LeavePolicy> applicablePolicies = allPolicies.stream()
                .filter(p -> (p.getEmployeeTypeId() != null && p.getEmployeeTypeId().equals(employeeTypeId))
                        || (p.getEmployeeTypeId() == null && p.getTenureRequiredDays() != null && tenureDays >= p.getTenureRequiredDays()))
                .toList();
        if (applicablePolicies.isEmpty()) {
            throw new IllegalStateException("No leave policies configured. Cannot initialize yearly balances.");
        }

        for (LeavePolicy policy : applicablePolicies) {
            // Skip CTO (since it’s earned dynamically)
            if (Boolean.TRUE.equals(policy.getLinkedToOvertime())) continue;

            LeaveBalanceEmployee balance = getLeaveBalanceEmployee(employeeId, year, policy);
            if (balance != null) {
                balanceRepository.save(balance);
            }
        }
    }

    private LeaveBalanceEmployee getLeaveBalanceEmployee(Long employeeId, int year, LeavePolicy policy) {
        LeaveBalanceEmployee balance = null;

        Optional<LeaveBalanceEmployee> balanceExists = balanceRepository
                .findByEmployeeIdAndLeaveTypeIdAndYear(employeeId, policy.getLeaveType().getId(), year);
        if (balanceExists.isEmpty()) {
            balance = new LeaveBalanceEmployee();
            balance.setEmployeeId(employeeId); // assuming you simplified Employee ref → employeeId
            balance.setLeaveType(policy.getLeaveType());
            balance.setYear(year);
            balance.setEntitledDays(BigDecimal.valueOf(policy.getDefaultQuota()));
            balance.setCarriedForward(BigDecimal.ZERO);
            balance.setEncashed(BigDecimal.ZERO);
            balance.setUsedDays(BigDecimal.ZERO);
            balance.recalculateBalance();
        }
        return balance;
    }

    // Deduct leave from balance
    @Transactional
    @Override
    public boolean applyLeave(LeaveRequest request) {
        Employee employee = getEmployee(request.getEmployeeId());
        LeaveGroupAssign leaveGroupAssign = validateLeaveGroupAssignee(employee);
        LeaveType leaveType = getLeaveType(request.getLeaveType().getId());
        LeavePolicy policy = getLeavePolicy(employee, leaveType, leaveGroupAssign);
        request.setLeaveGroupAssign(leaveGroupAssign);

        validateLeaveBalance(getLeaveBalance(request, leaveType), request.getDaysRequested());
        validateLeaveRequest(employee, request, policy);
        validateAndAssignCoveringEmployee(request);

        return true;
    }

    private LeaveGroupAssign validateLeaveGroupAssignee(Employee employee) {
        return leaveGroupAssignService.findApplicableLeaveGroup(employee);
    }

    // Apply carry forward at year-end
    @Transactional
    @Override
    public void processYearEnd(Long employeeId, int year) {
        carryForwardBalances(employeeId, year);
    }

    @Override
    @Transactional
    public void accrueLeave(Long employeeId, Long leaveTypeId, int year, Integer daysWorked) {

        LeaveType leaveType = leaveTypeRepository.findById(leaveTypeId)
                .orElseThrow(() -> new RuntimeException("LeaveType not found: " + leaveTypeId));

        LeavePolicy policy = policyRepository.findByLeaveType(leaveType)
                .orElseThrow(() -> new RuntimeException("Policy not found for leave type: " + leaveType.getName()));

        LeaveBalanceEmployee balance = balanceRepository
                .findByEmployeeIdAndLeaveTypeAndYear(employeeId, leaveType, year)
                .orElseThrow(() -> new RuntimeException("Balance not initialized"));

        // Accrual-based leave
        if (isAccrualBased(policy)) {
            BigDecimal entitled = calculateAccrualEntitled(balance, policy);
            updateBalance(balance, entitled);
        }

        // Earned leave
        if (Boolean.TRUE.equals(policy.getEarnedLeave()) && daysWorked != null) {
            BigDecimal earned = calculateEarnedLeave(policy, BigDecimal.valueOf(daysWorked));
            updateBalance(balance, earned);
        }

        balanceRepository.save(balance);
    }


    private boolean isAccrualBased(LeavePolicy policy) {
        return policy.getAccrualRatePerMonth() != null && policy.getAccrualRatePerMonth() > 0;
    }

    private BigDecimal calculateAccrualEntitled(LeaveBalanceEmployee balance, LeavePolicy policy) {
        BigDecimal entitled = balance.getEntitledDays() == null ? BigDecimal.ZERO : balance.getEntitledDays();
        entitled = entitled.add(BigDecimal.valueOf(policy.getAccrualRatePerMonth()));

        if (policy.getDefaultQuota() != null && entitled.compareTo(BigDecimal.valueOf(policy.getDefaultQuota())) > 0) {
            entitled = BigDecimal.valueOf(policy.getDefaultQuota());
        }
        return entitled;
    }

    private BigDecimal calculateEarnedLeave(LeavePolicy policy, BigDecimal daysWorked) {
        if (policy.getEarnedAfterDays() == null || policy.getEarnedLeaveDays() == null) {
            return BigDecimal.ZERO; // guard clause
        }

        BigDecimal earnedAfterDays = BigDecimal.valueOf(policy.getEarnedAfterDays());
        BigDecimal earnedLeaveDays = BigDecimal.valueOf(policy.getEarnedLeaveDays());

        if (earnedAfterDays.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO; // avoid division by zero or negative values
        }

        // (daysWorked / earnedAfterDays) * earnedLeaveDays
        return daysWorked
                .divide(earnedAfterDays, 2, RoundingMode.HALF_UP) // scale = 2 for precision
                .multiply(earnedLeaveDays);
    }

    private void updateBalance(LeaveBalanceEmployee balance, BigDecimal entitledIncrement) {
        BigDecimal entitled = (balance.getEntitledDays() == null ? BigDecimal.ZERO : balance.getEntitledDays()).add(entitledIncrement);
        BigDecimal currentBalance = (balance.getBalance() == null ? BigDecimal.ZERO : balance.getBalance()).add(entitledIncrement);

        balance.setEntitledDays(entitled);
        balance.setBalance(currentBalance);
        balance.recalculateBalance();
    }

    public void carryForwardBalances(Long employeeId, int year) {
        List<LeaveBalanceEmployee> balances = balanceRepository.findByEmployeeIdAndYear(employeeId, year);

        for (LeaveBalanceEmployee balance : balances) {
            LeavePolicy policy = policyRepository.findByLeaveType(balance.getLeaveType())
                    .orElseThrow(() -> new RuntimeException("Policy not found"));

            if (Boolean.TRUE.equals(policy.getCarryForwardAllowed())) {
                BigDecimal remaining = balance.getBalance();
                BigDecimal carryForwardCap = policy.getCarryForwardCap() != null ? BigDecimal.valueOf(policy.getCarryForwardCap()) : remaining;
                BigDecimal daysToCarry = remaining.min(carryForwardCap);

                balance.setBalance(daysToCarry);
            } else {
                balance.setBalance(BigDecimal.ZERO); // reset to 0 if not allowed
            }

            balanceRepository.save(balance);
        }
    }

    private Employee getEmployee(Long employeeId) {
        return employeeRepository.findById(employeeId)
                .orElseThrow(() -> new LeaveBalanceEmployeeNotFoundException("Employee not found: " + employeeId));
    }

    private LeaveType getLeaveType(Long leaveTypeId) {
        return leaveTypeRepository.findById(leaveTypeId)
                .orElseThrow(() -> new LeaveTypeNotFoundException("LeaveType not found: " + leaveTypeId));
    }

    private LeavePolicy getLeavePolicy(Employee employee, LeaveType leaveType, LeaveGroupAssign leaveGroupAssign) {
        long tenureDays = ChronoUnit.DAYS.between(employee.getDateOfJoining(), LocalDate.now());
        Long employeeTypeId = employee.getEmployeeType().getId();
        List<LeavePolicy> policies = policyRepository.findByLeaveTypeAndLeaveGroupAssign(leaveType, leaveGroupAssign);

        Optional<LeavePolicy> matchedPolicy = policies.stream()
                .filter(p -> (p.getEmployeeTypeId() != null && p.getEmployeeTypeId().equals(employeeTypeId))
                        || (p.getEmployeeTypeId() == null && p.getTenureRequiredDays() != null && tenureDays >= p.getTenureRequiredDays()))
                .findFirst();

        return matchedPolicy.orElseThrow(() ->
                new IllegalStateException("No applicable leave policy configured. Cannot process leave request.")
        );
    }

    private LeaveBalanceEmployee getLeaveBalance(LeaveRequest request, LeaveType leaveType) {
        return balanceRepository.findByEmployeeIdAndLeaveTypeAndYear(
                        request.getEmployeeId(),
                        leaveType,
                        request.getStartDate().getYear()
                )
                .orElseThrow(() -> new LeaveBalanceEmployeeNotFoundException("Leave balance not found"));
    }

    private void validateLeaveRequest(Employee employee, LeaveRequest request, LeavePolicy policy) {
        ValidationResult result = leaveRuleEngine.validateRequest(employee, request, policy);
        if (!result.isValid()) {
            throw new ValidationException(result.getErrorCode(), result.getMessage());
        }
    }

    private void validateLeaveBalance(LeaveBalanceEmployee balance, BigDecimal daysRequested) {
        deductLeave(balance, daysRequested);
    }

    private void deductLeave(LeaveBalanceEmployee balance, BigDecimal daysRequested) {
        boolean success = balance.consumeLeave(daysRequested);
        if (!success) {
            throw new ValidationException("INSUFFICIENT_BALANCE", "Not enough leave balance");
        }
        balanceRepository.save(balance);
    }

    private void validateAndAssignCoveringEmployee(LeaveRequest request) {
        if (request.getCoveringEmployeeId() != null) {
            Employee covering = employeeRepository.findById(request.getCoveringEmployeeId())
                    .orElseThrow(() -> new ValidationException("COVERING_EMPLOYEE_NOT_FOUND", "Invalid covering employee"));

            boolean coveringUnavailable = leaveRequestRepository.existsByEmployeeIdAndStartDateBetween(
                    covering.getId(),
                    request.getStartDate(),
                    request.getEndDate()
            );

            if (coveringUnavailable) {
                throw new ValidationException("COVERING_EMPLOYEE_UNAVAILABLE",
                        "Covering employee is already on leave during this period");
            }

            request.setCoveringEmployeeId(covering.getId());
        }
    }

    @Override
    public void deductLeaveBalance(LeaveRequest leaveRequest) {
        Long employeeId = leaveRequest.getEmployeeId();
        Long leaveTypeId = leaveRequest.getLeaveType().getId();
        int year = leaveRequest.getStartDate().getYear();

        LeaveBalanceEmployee balance = balanceRepository
                .findByEmployeeIdAndLeaveTypeIdAndYear(employeeId, leaveTypeId, year)
                .orElseThrow(() -> new RuntimeException("Leave balance not found for employee: " + employeeId));

        BigDecimal daysToConsume = leaveRequest.getDaysRequested();
        boolean deducted = balance.consumeLeave(daysToConsume);

        if (!deducted) {
            throw new RuntimeException("Insufficient leave balance for employee: " + employeeId);
        }

        balance.recalculateBalance();
        balanceRepository.save(balance);

        System.out.println("✅ Deducted " + daysToConsume + " days for employee " + employeeId +
                ". New balance: " + balance.getBalance());
    }

    @Override
    public void deleteLeaveBalance(Long id) {
        LeaveBalanceEmployee balance = balanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Leave balance not found with id: " + id));

        balanceRepository.delete(balance);
    }
}
