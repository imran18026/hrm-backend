package com.betopia.hrm.services.leaves.leaveapproval.impl;

import com.betopia.hrm.domain.base.response.pagination.PaginationResponse;
import com.betopia.hrm.domain.dto.leave.LeaveApprovalsDTO;
import com.betopia.hrm.domain.dto.leave.mapper.LeaveApprovalsMapper;
import com.betopia.hrm.domain.employee.entity.Employee;
import com.betopia.hrm.domain.employee.repository.EmployeeRepository;
import com.betopia.hrm.domain.leave.entity.LeaveApprovals;
import com.betopia.hrm.domain.leave.entity.LeaveRequest;
import com.betopia.hrm.domain.leave.enums.LeaveStatus;
import com.betopia.hrm.domain.leave.repository.LeaveApprovalsRepository;
import com.betopia.hrm.domain.leave.repository.LeaveRequestRepository;
import com.betopia.hrm.domain.leave.request.LeaveApprovalsRequest;
import com.betopia.hrm.domain.leave.request.StatusApproveRequest;
import com.betopia.hrm.services.leaves.leaveapproval.LeaveApprovalsService;
import com.betopia.hrm.services.leaves.leavebalanceemployee.LeaveBalanceEmployeeService;
import com.betopia.hrm.services.leaves.leavenotifications.LeaveNotificationsService;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class LeaveApprovalsServiceImpl implements LeaveApprovalsService {

    public final LeaveApprovalsRepository leaveApprovalsRepository;
    public final LeaveApprovalsMapper leaveApprovalsMapper;
    private final EmployeeRepository employeeRepository;
    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveBalanceEmployeeService balanceEmployeeService;
    private final LeaveNotificationsService leaveNotificationsService;


    public LeaveApprovalsServiceImpl(LeaveApprovalsRepository leaveApprovalsRepository,
                                     LeaveApprovalsMapper leaveApprovalsMapper, EmployeeRepository employeeRepository,
                                     LeaveRequestRepository leaveRequestRepository,
                                     LeaveBalanceEmployeeService balanceEmployeeService,
                                     LeaveNotificationsService leaveNotificationsService) {

        this.leaveApprovalsMapper = leaveApprovalsMapper;
        this.leaveApprovalsRepository = leaveApprovalsRepository;
        this.employeeRepository = employeeRepository;
        this.leaveRequestRepository = leaveRequestRepository;
        this.balanceEmployeeService = balanceEmployeeService;
        this.leaveNotificationsService = leaveNotificationsService;
    }

    @Override
    public PaginationResponse<LeaveApprovalsDTO> index(Sort.Direction direction, int page, int perPage) {
        return null;
    }

    @Override
    public List<LeaveApprovalsDTO> getAll() {
        List<LeaveApprovals> leaveApprovals = leaveApprovalsRepository.findAll();
        return leaveApprovalsMapper.toDTOList(leaveApprovals);
    }

    @Override
    public LeaveApprovalsDTO store(LeaveApprovalsRequest request) {
        LeaveApprovals leaveApprovals = new LeaveApprovals();

        Employee employee = employeeRepository.findById(leaveApprovals.getLeaveRequest().getEmployeeId())
                .orElseThrow(() -> new RuntimeException("Employee not found with id: " + leaveApprovals.getLeaveRequest().getEmployeeId()));

        // Get supervisor entity
        Long supervisorId = employee.getSupervisorId();

        leaveApprovals.setApproverId(supervisorId);

        leaveApprovals.setLeaveRequest(leaveRequestRepository.findById(request.leaveRequestId())
                .orElseThrow(() -> new RuntimeException("Leave request id not found")));


        leaveApprovals.setEmployee(employee);
        leaveApprovals.setLevel(request.level());
        leaveApprovals.setLeaveStatus(request.leaveStatus());
        leaveApprovals.setRemarks(request.remarks());

        leaveApprovals.setActionDate(request.actionDate());


        // Save entity
        LeaveApprovals save = leaveApprovalsRepository.save(leaveApprovals);

        LeaveRequest leaveRequest = leaveRequestRepository.findById(
                leaveApprovals.getLeaveRequest().getId()
        ).orElseThrow(() -> new RuntimeException("LeaveRequest not found with id: " + leaveApprovals.getLeaveRequest().getId()));

        // Step 3: Update the related leave request status
        leaveRequest.setStatus(request.leaveStatus());
        leaveRequestRepository.save(leaveRequest);

        // Step 4: If approved, deduct leave from balance
        if (request.leaveStatus() == LeaveStatus.APPROVED) {
            balanceEmployeeService.deductLeaveBalance(leaveRequest);
        }

        // Convert Entity to DTO and return
        return leaveApprovalsMapper.toDTO(save);
    }

    @Override
    public LeaveApprovalsDTO show(Long id) {
        LeaveApprovals leaveApprovals = leaveApprovalsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("approval not found with id: " + id));
        return leaveApprovalsMapper.toDTO(leaveApprovals);
    }

    @Override
    public LeaveApprovalsDTO update(Long id, LeaveApprovalsRequest request) {
        LeaveApprovals leaveApprovals = leaveApprovalsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Leave approve not found with id: " + id));

        Employee employee = employeeRepository.findById(leaveApprovals.getLeaveRequest().getEmployeeId())
                .orElseThrow(() -> new RuntimeException("Employee not found with id: " + leaveApprovals.getLeaveRequest().getEmployeeId()));

        // Get supervisor entity
        Long supervisorId = employee.getSupervisorId();

        leaveApprovals.setApproverId(supervisorId);

        leaveApprovals.setLeaveRequest(leaveRequestRepository.findById(request.leaveRequestId())
                .orElseThrow(() -> new RuntimeException("Leave request id not found")));

        leaveApprovals.setEmployee(employee);
        leaveApprovals.setLevel(request.level());
        leaveApprovals.setLeaveStatus(request.leaveStatus());
        leaveApprovals.setRemarks(request.remarks());

        leaveApprovals.setActionDate(request.actionDate());


        // Save entity
        LeaveApprovals update = leaveApprovalsRepository.save(leaveApprovals);

        // Convert Entity to DTO and return
        return leaveApprovalsMapper.toDTO(update);
    }

    @Override
    public void destroy(Long id) {

        LeaveApprovals leaveApprovals = leaveApprovalsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("approval not found"));

        leaveApprovalsRepository.delete(leaveApprovals);

    }

    @Override
    public LeaveApprovalsDTO createInitialApproval(LeaveRequest request) {
        // Get the employee who requested the leave
        Employee employee = employeeRepository.findById(request.getEmployeeId())
                .orElseThrow(() -> new RuntimeException("Employee not found with id: " + request.getEmployeeId()));

        // Get supervisor entity
        Long supervisorId = employee.getSupervisorId();
        System.err.println("employee "+request.getEmployeeId());
        System.err.println("supervisor "+supervisorId);
        if (supervisorId == null) {
            throw new IllegalStateException("Employee " + employee.getId() + " does not have a supervisor assigned");
        }

        LeaveRequest leaveRequest = leaveRequestRepository.findById(request.getId())
                .orElseThrow(() -> new RuntimeException("Leave request not found with id: " + request.getId()));

        // Create leave approval entity
        LeaveApprovals approval = new LeaveApprovals();
        approval.setEmployee(employee);
        approval.setLeaveRequest(leaveRequest); // set leave request entity
        approval.setApproverId(supervisorId);       // set supervisor entity
        approval.setLevel(1);                    // first approval level
        approval.setLeaveStatus(request.getStatus());

        // Save and return as DTO
        LeaveApprovals saved = leaveApprovalsRepository.save(approval);

        leaveNotificationsService.createInitialNotification(saved);
        System.err.println("NOTIFICATIONSSS");

        return leaveApprovalsMapper.toDTO(saved);
    }

    @Transactional
    @Override
    public LeaveApprovalsDTO updateLeaveStatus(Long id, StatusApproveRequest request) {
        // Step 1: Get existing approval entry
        LeaveApprovals approval = leaveApprovalsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Leave approval not found with id: " + id));

        // Step 2: Update approval info
        approval.setLeaveStatus(request.leaveStatus());
        approval.setRemarks(request.remarks());
        approval.setActionDate(LocalDateTime.now());

        LeaveApprovals saved = leaveApprovalsRepository.save(approval);

        LeaveRequest leaveRequest = leaveRequestRepository.findById(
                approval.getLeaveRequest().getId()
        ).orElseThrow(() -> new RuntimeException("LeaveRequest not found with id: " + approval.getLeaveRequest().getId()));

        System.err.println("Before update: LeaveRequest ID=" + leaveRequest.getId() +
                ", Status=" + leaveRequest.getStatus() +
                ", Version=" + leaveRequest.getVersion());

        // Step 3: Update the related leave request status
        leaveRequest.setStatus(request.leaveStatus());
        leaveRequestRepository.save(leaveRequest);

        System.err.println("After update: LeaveRequest ID=" + leaveRequest.getId() +
                ", Status=" + leaveRequest.getStatus() +
                ", Version=" + leaveRequest.getVersion());


        // Step 4: If approved, deduct leave from balance
        if (request.leaveStatus() == LeaveStatus.APPROVED) {
            balanceEmployeeService.deductLeaveBalance(leaveRequest);
        }

        return leaveApprovalsMapper.toDTO(saved);
    }
}

