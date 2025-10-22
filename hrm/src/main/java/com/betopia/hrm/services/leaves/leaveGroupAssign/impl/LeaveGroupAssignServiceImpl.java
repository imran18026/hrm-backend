package com.betopia.hrm.services.leaves.leaveGroupAssign.impl;

import com.betopia.hrm.domain.base.response.pagination.Links;
import com.betopia.hrm.domain.base.response.pagination.Meta;
import com.betopia.hrm.domain.base.response.pagination.PaginationResponse;
import com.betopia.hrm.domain.company.entity.BusinessUnit;
import com.betopia.hrm.domain.company.entity.WorkplaceGroup;
import com.betopia.hrm.domain.company.repository.BusinessUnitRepository;
import com.betopia.hrm.domain.company.repository.DepartmentRepository;
import com.betopia.hrm.domain.company.repository.TeamRepository;
import com.betopia.hrm.domain.company.repository.WorkplaceGroupRepository;
import com.betopia.hrm.domain.dto.leave.LeaveGroupAssignDTO;
import com.betopia.hrm.domain.dto.leave.mapper.LeaveGroupAssignMapper;
import com.betopia.hrm.domain.employee.entity.Employee;
import com.betopia.hrm.domain.leave.entity.LeaveGroup;
import com.betopia.hrm.domain.leave.entity.LeaveGroupAssign;
import com.betopia.hrm.domain.leave.entity.LeaveType;
import com.betopia.hrm.domain.leave.exception.leaveGroupAssign.LeaveGroupAssignNotFoundException;
import com.betopia.hrm.domain.leave.repository.LeaveGroupAssignRepository;
import com.betopia.hrm.domain.leave.repository.LeaveGroupRepository;
import com.betopia.hrm.domain.leave.repository.LeaveTypeRepository;
import com.betopia.hrm.domain.leave.request.LeaveGroupAssignRequest;
import com.betopia.hrm.domain.leave.specification.LeaveGroupAssignSpecification;
import com.betopia.hrm.domain.users.entity.Company;
import com.betopia.hrm.domain.users.entity.Workplace;
import com.betopia.hrm.domain.users.repository.CompanyRepository;
import com.betopia.hrm.domain.users.repository.WorkplaceRepository;
import com.betopia.hrm.services.leaves.leaveGroupAssign.LeaveGroupAssignService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LeaveGroupAssignServiceImpl implements LeaveGroupAssignService {

    private final LeaveGroupAssignRepository leaveGroupAssignRepository;

    private final LeaveTypeRepository leaveTypeRepository;

    private final LeaveGroupRepository leaveGroupRepository;

    private final CompanyRepository CompanyRepository;

    private final BusinessUnitRepository businessUnitRepository;

    private final WorkplaceGroupRepository workplaceGroupRepository;

    private final WorkplaceRepository workplaceRepository;

    private final DepartmentRepository departmentRepository;

    private final TeamRepository teamRepository;

    private final LeaveGroupAssignMapper leaveGroupAssignMapper;

    public LeaveGroupAssignServiceImpl(
            LeaveGroupAssignRepository leaveGroupAssignRepository,
            LeaveTypeRepository leaveTypeRepository,
            LeaveGroupRepository leaveGroupRepository,
            CompanyRepository companyRepository,
            BusinessUnitRepository businessUnitRepository,
            WorkplaceGroupRepository workplaceGroupRepository,
            WorkplaceRepository workplaceRepository,
            DepartmentRepository departmentRepository,
            TeamRepository teamRepository,
            LeaveGroupAssignMapper leaveGroupAssignMapper
    ) {
        this.leaveGroupAssignRepository = leaveGroupAssignRepository;
        this.leaveTypeRepository = leaveTypeRepository;
        this.leaveGroupRepository = leaveGroupRepository;
        CompanyRepository = companyRepository;
        this.businessUnitRepository = businessUnitRepository;
        this.workplaceGroupRepository = workplaceGroupRepository;
        this.workplaceRepository = workplaceRepository;
        this.departmentRepository = departmentRepository;
        this.teamRepository = teamRepository;
        this.leaveGroupAssignMapper = leaveGroupAssignMapper;
    }

    @Override
    public PaginationResponse<LeaveGroupAssignDTO> index(Sort.Direction direction, int page, int perPage) {
        Pageable pageable = PageRequest.of(page - 1, perPage, Sort.by(direction, "id"));
        Page<LeaveGroupAssign> leaveGroupAssignPage = leaveGroupAssignRepository.findAll(pageable);
        List<LeaveGroupAssignDTO> leaveGroupAssigns = leaveGroupAssignPage.getContent()
                .stream()
                .map(leaveGroupAssignMapper::toDTO)
                .toList();

        PaginationResponse<LeaveGroupAssignDTO> response = new PaginationResponse<>();
        response.setData(leaveGroupAssigns);
        response.setSuccess(true);
        response.setStatusCode(HttpStatus.OK.value());
        response.setMessage("All leave group assigns fetched successfully");

        Links links = Links.fromPage(leaveGroupAssignPage, "/leave-group-assigns");
        response.setLinks(links);

        Meta meta = Meta.fromPage(leaveGroupAssignPage, "/leave-group-assigns");
        response.setMeta(meta);

        return response;
    }

    @Override
    public List<LeaveGroupAssignDTO> getAllLeaveGroupAssigns() {

        return leaveGroupAssignRepository.findAll(Sort.by(Sort.Direction.DESC, "id"))
                .stream()
                .map(leaveGroupAssignMapper::toDTO)
                .toList();
    }

    @Override
    public LeaveGroupAssignDTO store(LeaveGroupAssignRequest request) {
        LeaveGroupAssign leaveGroupAssign = new LeaveGroupAssign();

        LeaveType leaveType = leaveTypeRepository.findById(request.leaveTypeId())
                .orElseThrow(() -> new RuntimeException("LeaveType not found with id: " + request.leaveTypeId()));

        LeaveGroup leaveGroup = leaveGroupRepository.findById(request.leaveGroupId())
                .orElseThrow(() -> new RuntimeException("LeaveGroup not found with id: " + request.leaveGroupId()));

        if (leaveGroupAssignRepository.existsByLeaveTypeAndLeaveGroup(
                leaveGroupAssign.getLeaveType(),
                leaveGroupAssign.getLeaveGroup())
        ) {
            throw new IllegalArgumentException("Duplicate LeaveType and LeaveGroup combination already exists");
        }

        leaveGroupAssign.setLeaveType(leaveType);
        leaveGroupAssign.setLeaveGroup(leaveGroup);

        Company company = CompanyRepository.findById(request.companyId())
                .orElseThrow(() -> new RuntimeException("Company not found with id: " + request.companyId()));
        leaveGroupAssign.setCompany(company);

        BusinessUnit businessUnit = businessUnitRepository.findById(request.businessUnitId())
                .orElseThrow(() -> new RuntimeException("BusinessUnit not found with id: " + request.businessUnitId()));
        leaveGroupAssign.setBusinessUnit(businessUnit);

        WorkplaceGroup workplaceGroup = workplaceGroupRepository.findById(request.workPlaceGroupId())
                .orElseThrow(() -> new RuntimeException("WorkplaceGroup not found with id: " + request.workPlaceGroupId()));
        leaveGroupAssign.setWorkplaceGroup(workplaceGroup);

        Workplace workplace = workplaceRepository.findById(request.workPlaceId())
                .orElseThrow(() -> new RuntimeException("Workplace not found with id: " + request.workPlaceId()));
        leaveGroupAssign.setWorkplace(workplace);

        leaveGroupAssign.setDescription(request.description());
        leaveGroupAssign.setStatus(request.status());

        return leaveGroupAssignMapper.toDTO(leaveGroupAssignRepository.save(leaveGroupAssign));
    }

    @Override
    public LeaveGroupAssignDTO show(Long leaveGroupAssignId) {
        LeaveGroupAssign leaveGroupAssign = leaveGroupAssignRepository.findById(leaveGroupAssignId)
                .orElseThrow(() -> new LeaveGroupAssignNotFoundException("LeaveGroupAssign not found with id: " + leaveGroupAssignId));

        return leaveGroupAssignMapper.toDTO(leaveGroupAssign);
    }

    @Override
    public LeaveGroupAssignDTO update(Long leaveGroupAssignId, LeaveGroupAssignRequest request) {
        LeaveGroupAssign leaveGroupAssign = leaveGroupAssignRepository.findById(leaveGroupAssignId)
                .orElseThrow(() -> new LeaveGroupAssignNotFoundException("LeaveGroupAssign not found with id: " + leaveGroupAssignId));

        if (leaveGroupAssignRepository.existsByLeaveTypeAndLeaveGroupAndIdNot(
                leaveGroupAssign.getLeaveType(), leaveGroupAssign.getLeaveGroup(), leaveGroupAssignId)) {
            throw new IllegalArgumentException("Duplicate LeaveType and LeaveGroup combination already exists");
        }

        LeaveType leaveType = leaveTypeRepository.findById(request.leaveTypeId())
                .orElseThrow(() -> new RuntimeException("LeaveType not found with id: " + request.leaveTypeId()));

        LeaveGroup leaveGroup = leaveGroupRepository.findById(request.leaveGroupId())
                .orElseThrow(() -> new RuntimeException("LeaveGroup not found with id: " + request.leaveGroupId()));

        leaveGroupAssign.setLeaveType(leaveType != null ? leaveType : leaveGroupAssign.getLeaveType());
        leaveGroupAssign.setLeaveGroup(leaveGroup != null ? leaveGroup : leaveGroupAssign.getLeaveGroup());

        Company company = CompanyRepository.findById(request.companyId())
                .orElseThrow(() -> new RuntimeException("Company not found with id: " + request.companyId()));
        leaveGroupAssign.setCompany(company != null ? company : leaveGroupAssign.getCompany());

        BusinessUnit businessUnit = businessUnitRepository.findById(request.businessUnitId())
                .orElseThrow(() -> new RuntimeException("BusinessUnit not found with id: " + request.businessUnitId()));
        leaveGroupAssign.setBusinessUnit(businessUnit != null ? businessUnit : leaveGroupAssign.getBusinessUnit());

        WorkplaceGroup workplaceGroup = workplaceGroupRepository.findById(request.workPlaceGroupId())
                .orElseThrow(() -> new RuntimeException("WorkplaceGroup not found with id: " + request.workPlaceGroupId()));
        leaveGroupAssign.setWorkplaceGroup(workplaceGroup != null ? workplaceGroup : leaveGroupAssign.getWorkplaceGroup());

        Workplace workplace = workplaceRepository.findById(request.workPlaceId())
                .orElseThrow(() -> new RuntimeException("Workplace not found with id: " + request.workPlaceId()));
        leaveGroupAssign.setWorkplace(workplace != null ? workplace : leaveGroupAssign.getWorkplace());

        leaveGroupAssign.setDepartment(request.departmentId() != null ? departmentRepository.findById(request.departmentId())
                .orElseThrow(() -> new RuntimeException("Department not found with id: " + request.departmentId())) : leaveGroupAssign.getDepartment());

        leaveGroupAssign.setTeam(request.teamId() != null ? teamRepository.findById(request.teamId())
                .orElseThrow(() -> new RuntimeException("Team not found with id: " + request.teamId())) : leaveGroupAssign.getTeam());
        leaveGroupAssign.setDescription(request.description() != null ? request.description() : leaveGroupAssign.getDescription());
        leaveGroupAssign.setStatus(request.status() != null ? request.status() : leaveGroupAssign.getStatus());

        leaveGroupAssignRepository.save(leaveGroupAssign);

        return leaveGroupAssignMapper.toDTO(leaveGroupAssign);
    }

    @Override
    public void destroy(Long leaveGroupAssignId) {

        LeaveGroupAssign leaveGroupAssign = leaveGroupAssignRepository.findById(leaveGroupAssignId)
                .orElseThrow(() -> new LeaveGroupAssignNotFoundException("LeaveGroupAssign not found with id: " + leaveGroupAssignId));

        leaveGroupAssignRepository.delete(leaveGroupAssign);
    }

    @Override
    public LeaveGroupAssign findApplicableLeaveGroup(Employee employee) {
        Specification<LeaveGroupAssign> spec =
                LeaveGroupAssignSpecification.applicableForEmployee(employee);

        // fetch best match only
        return leaveGroupAssignRepository.findAll(spec, PageRequest.of(0, 1))
                .stream()
                .findFirst()
                .orElseThrow(() -> new IllegalStateException(
                        "No LeaveGroupAssign found for employee ID: " + employee.getId()));
    }
}
