package com.betopia.hrm.services.employee.impl;

import com.betopia.hrm.domain.base.response.pagination.Links;
import com.betopia.hrm.domain.base.response.pagination.Meta;
import com.betopia.hrm.domain.base.response.pagination.PaginationResponse;
import com.betopia.hrm.domain.company.entity.BusinessUnit;
import com.betopia.hrm.domain.company.entity.Department;
import com.betopia.hrm.domain.company.entity.Team;
import com.betopia.hrm.domain.company.entity.WorkplaceGroup;
import com.betopia.hrm.domain.company.repository.BusinessUnitRepository;
import com.betopia.hrm.domain.company.repository.DepartmentRepository;
import com.betopia.hrm.domain.company.repository.TeamRepository;
import com.betopia.hrm.domain.company.repository.WorkplaceGroupRepository;
import com.betopia.hrm.domain.dto.employee.EmployeeDTO;
import com.betopia.hrm.domain.dto.employee.mapper.EmployeeDTOMapper;
import com.betopia.hrm.domain.employee.entity.Designation;
import com.betopia.hrm.domain.employee.entity.Employee;
import com.betopia.hrm.domain.employee.entity.EmployeeType;
import com.betopia.hrm.domain.employee.entity.Grade;
import com.betopia.hrm.domain.employee.exception.employee.EmployeeNotFound;
import com.betopia.hrm.domain.employee.mapper.EmployeeMapper;
import com.betopia.hrm.domain.employee.repository.DesignationRepository;
import com.betopia.hrm.domain.employee.repository.EmployeeRepository;
import com.betopia.hrm.domain.employee.repository.EmployeeTypeRepository;
import com.betopia.hrm.domain.employee.repository.GradeRepository;
import com.betopia.hrm.domain.employee.request.EmployeeRequest;
import com.betopia.hrm.domain.users.entity.Company;
import com.betopia.hrm.domain.users.entity.User;
import com.betopia.hrm.domain.users.entity.Workplace;
import com.betopia.hrm.domain.users.exception.role.RoleNotFoundException;
import com.betopia.hrm.domain.users.repository.CompanyRepository;
import com.betopia.hrm.domain.users.repository.RoleRepository;
import com.betopia.hrm.domain.users.repository.UserRepository;
import com.betopia.hrm.domain.users.repository.WorkplaceRepository;
import com.betopia.hrm.services.employee.EmployeeService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.criteria.Predicate;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class EmployeeServiceImpl implements EmployeeService {

    private final EmployeeRepository employeeRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmployeeMapper employeeMapper;
    private final RoleRepository roleRepository;
    private final CompanyRepository companyRepository;
    private final DepartmentRepository departmentRepository;
    private final WorkplaceRepository workplaceRepository;
    private final EmployeeTypeRepository employeeTypeRepository;
    private final GradeRepository gradeRepository;
    private final WorkplaceGroupRepository workplaceGroupRepository;
    private final BusinessUnitRepository businessUnitRepository;
    private final DesignationRepository designationRepository;
    private final TeamRepository teamRepository;
    private final EmployeeDTOMapper employeeDTOMapper;

    @Value("${user.default.password}")
    private String userDefaultPassword;
    private long empSerialId = 0;

    public EmployeeServiceImpl(EmployeeRepository employeeRepository, EmployeeMapper employeeMapper,
                               UserRepository userRepository, PasswordEncoder passwordEncoder, RoleRepository roleRepository, CompanyRepository companyRepository, DepartmentRepository departmentRepository, WorkplaceRepository workplaceRepository, EmployeeTypeRepository employeeTypeRepository, GradeRepository gradeRepository, WorkplaceGroupRepository workplaceGroupRepository, BusinessUnitRepository businessUnitRepository, DesignationRepository designationRepository, TeamRepository teamRepository, EmployeeDTOMapper employeeDTOMapper) {
        this.employeeRepository = employeeRepository;
        this.userRepository = userRepository;
        this.employeeMapper = employeeMapper;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
        this.companyRepository = companyRepository;
        this.departmentRepository = departmentRepository;
        this.workplaceRepository = workplaceRepository;
        this.employeeTypeRepository = employeeTypeRepository;
        this.gradeRepository = gradeRepository;
        this.workplaceGroupRepository = workplaceGroupRepository;
        this.businessUnitRepository = businessUnitRepository;
        this.designationRepository = designationRepository;
        this.teamRepository = teamRepository;
        this.employeeDTOMapper = employeeDTOMapper;
    }

    @Override
    public PaginationResponse<EmployeeDTO> index(Sort.Direction direction, int page, int perPage) {
        Pageable pageable = PageRequest.of(page -1, perPage, Sort.by(direction, "id"));

        Page<Employee> employeePage = employeeRepository.findAll(pageable);

        List<Employee> employees = employeePage.getContent();
        List<EmployeeDTO> advanceCashRequestDTOs = employeeDTOMapper.toDTOList(employees);

        PaginationResponse<EmployeeDTO> response = new PaginationResponse<>();

        response.setData(advanceCashRequestDTOs);
        response.setSuccess(true);
        response.setStatusCode(HttpStatus.OK.value());
        response.setMessage("All employee fetch successful");

        Links links = Links.fromPage(employeePage, "/employees");
        response.setLinks(links);

        Meta meta = Meta.fromPage(employeePage, "/employees");
        response.setMeta(meta);

        return response;
    }

    @Override
    public PaginationResponse<EmployeeDTO> searchEmployees(Long departmentId, Long designationId, Long workplaceId, Long workPlaceGroupId, Long companyId, Long gradeId, Long employeeTypeId, String employeeName,Pageable pageable) {

     Specification<Employee> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (departmentId != null)
                predicates.add(cb.equal(root.get("department").get("id"), departmentId));

            if (designationId != null)
                predicates.add(cb.equal(root.get("designation").get("id"), designationId));

            if (workplaceId != null)
                predicates.add(cb.equal(root.get("workplace").get("id"), workplaceId));

            if (workPlaceGroupId != null)
                predicates.add(cb.equal(root.get("workPlaceGroup").get("id"), workPlaceGroupId));

            if (companyId != null)
                predicates.add(cb.equal(root.get("company").get("id"), companyId));

            if (gradeId != null)
                predicates.add(cb.equal(root.get("grade").get("id"), gradeId));

            if (employeeTypeId != null)
                predicates.add(cb.equal(root.get("employeeType").get("id"), employeeTypeId));

            if (employeeName != null && !employeeName.trim().isEmpty())
                predicates.add(cb.like(cb.lower(root.get("firstName")), "%" + employeeName.toLowerCase() + "%"));

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Employee> employeePage = employeeRepository.findAll(spec, pageable);

        List<Employee> employees = employeePage.getContent();

        List<EmployeeDTO> advanceCashRequestDTOs = employeeDTOMapper.toDTOList(employees);
        PaginationResponse<EmployeeDTO> response = new PaginationResponse<>();

        response.setData(advanceCashRequestDTOs);
        response.setSuccess(true);
        response.setStatusCode(HttpStatus.OK.value());
        response.setMessage("Employee fetch successful");

        Links links = Links.fromPage(employeePage, "/employees");
        response.setLinks(links);

        Meta meta = Meta.fromPage(employeePage, "/employees");
        response.setMeta(meta);

        return response;
    }


    @Override
    public List<EmployeeDTO> getAllEmployees() {

        return employeeRepository.findAll(Sort.by(Sort.Direction.DESC, "id"))
                .stream().map(employeeDTOMapper::toDTO).toList();
    }

    @Override
    @Transactional
    public EmployeeDTO store(EmployeeRequest request) {

        System.out.println("Request " + request);
        Employee employee =employeeMapper.toEntity(request);
        empSerialId=employeeRepository.nextEmployeeSerial();
        employee.setEmployeeSerialId(empSerialId);
        employeeRepository.save(employee);
        insertUser(employee,request);

        return employeeDTOMapper.toDTO(employee);
    }

    private void insertUser(Employee employee, EmployeeRequest request) {

        User user = new User();
        user.setEmail(employee.getEmail());
        user.setActive(true);
        user.setUserType("Employee");
        user.setEmployeeSerialId(Math.toIntExact(empSerialId));
        user.setPhone(employee.getPhone());
        user.setName(employee.getFirstName());
        user.setPassword(passwordEncoder.encode(userDefaultPassword));
        user.setRoles(roleRepository.findById(request.roleId()).orElseThrow(() -> new RoleNotFoundException("Role not found with id: " + request.roleId())));
        userRepository.save(user);
    }

    @Override
    public EmployeeDTO show(Long employeeId) {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EmployeeNotFound("Employee not found with id: " + employeeId));

        return employeeDTOMapper.toDTO(employee);
    }

    @Override
    public EmployeeDTO update(Long employeeId, EmployeeRequest request) {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EmployeeNotFound("Employee not found with id: " + employeeId));

        employee.setFirstName(request.firstName());
        employee.setLastName(request.lastName());
        employee.setEmail(request.email());
        employee.setPresentAddress(request.presentAddress());
        employee.setPermanentAddress(request.permanentAddress());
        employee.setMaritalStatus(request.maritalStatus());
        employee.setEmergencyContactName(request.emergencyContactName());
        employee.setEmergencyContactRelation(request.emergencyContactRelation());
        employee.setPhone(request.phone());
        employee.setPhoto(request.photo());
        employee.setGender(request.gender());
        employee.setDateOfJoining(request.dateOfJoining());
        employee.setSupervisorId(request.supervisorId());
        employee.setJobTitle(request.jobTitle());
        employee.setLineManagerId(request.lineManagerId());
        employee.setDeviceUserId(request.deviceUserId());
        employee.setGrossSalary(request.grossSalary());

        if(request.employeeTypeId()!=null) {
            EmployeeType employeeTypes = employeeTypeRepository.findById(request.employeeTypeId())
                    .orElseThrow(() -> new RuntimeException("EmployeeTypes not found: " + request.employeeTypeId()));
            employee.setEmployeeType(employeeTypes);
        }
        else
            employee.setEmployeeType(null);


        if(request.departmentId() != null) {
            Department department = departmentRepository.findById(request.departmentId())
                    .orElseThrow(() -> new RuntimeException("Department not found: " + request.departmentId()));
            employee.setDepartment(department);
        }
        else
            employee.setDepartment(null);


        if(request.designationId() != null) {
            Designation designation = designationRepository.findById(request.designationId())
                    .orElseThrow(() -> new RuntimeException("Designation not found: " + request.designationId()));
            employee.setDesignation(designation);
        }
        else
            employee.setDesignation(null);

        if(request.gradeId() != null) {
            Grade grade = gradeRepository.findById(request.gradeId())
                    .orElseThrow(() -> new RuntimeException("Grade not found: " + request.gradeId()));
            employee.setGrade(grade);
        }
        else
            employee.setGrade(null);

        if(request.companyId() != null){
            Company company = companyRepository.findById(request.companyId())
                    .orElseThrow(() -> new RuntimeException("Company not found: " + request.companyId()));
            employee.setCompany(company);
        }
        else
            employee.setCompany(null);

        if(request.workPlaceId() != null) {
            Workplace workplace = workplaceRepository.findById(request.workPlaceId())
                    .orElseThrow(() -> new RuntimeException("Workplace not found: " + request.workPlaceId()));
            employee.setWorkplace(workplace);
        }
        else
            employee.setWorkplace(null);

        if(request.workPlaceGroupId() != null) {
            WorkplaceGroup workplaceGroup = workplaceGroupRepository.findById(request.workPlaceGroupId())
                    .orElseThrow(() -> new RuntimeException("WorkplaceGroup not found: " + request.workPlaceGroupId()));
            employee.setWorkplaceGroup(workplaceGroup);
        }
        else
            employee.setWorkplaceGroup(null);

        if(request.businessUnitId() != null) {
            BusinessUnit businessUnit = businessUnitRepository.findById(request.businessUnitId())
                    .orElseThrow(() -> new RuntimeException("BusinessUnit not found: " + request.businessUnitId()));
            employee.setBusinessUnit(businessUnit);
        }
        else
            employee.setBusinessUnit(null);

        if(request.teamId() != null) {
            Team team = teamRepository.findById(request.teamId())
                    .orElseThrow(() -> new RuntimeException("Team not found: " + request.teamId()));
            employee.setTeam(team);
        }
        else
            employee.setTeam(null);
        employeeRepository.save(employee);
        return employeeDTOMapper.toDTO(employee);
    }

    @Override
    public void delete(Long employeeId) {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EmployeeNotFound("Employee not found with id: " + employeeId));

        employeeRepository.deleteById(employeeId);
    }

    public Long findReportingManagerId(Long employeeId) {
        return employeeRepository.findSupervisorIdByEmployeeId(employeeId)
                .map(Employee::getId)
                .orElseThrow(()->new EntityNotFoundException("Supervisor not found for employee ID: " + employeeId));
    }
}
