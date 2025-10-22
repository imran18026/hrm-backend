package com.betopia.hrm.services.hierarchyfilterservice.impl;

import com.betopia.hrm.domain.company.entity.*;
import com.betopia.hrm.domain.company.repository.*;
import com.betopia.hrm.domain.dto.company.*;
import com.betopia.hrm.domain.dto.hierarchyfilter.HierarchyFilterDTO;
import com.betopia.hrm.domain.dto.hierarchyfilter.mapper.HierarchyFilterMapper;
import com.betopia.hrm.domain.users.entity.Company;
import com.betopia.hrm.domain.users.entity.Workplace;
import com.betopia.hrm.domain.users.repository.CompanyRepository;
import com.betopia.hrm.domain.users.repository.WorkplaceRepository;
import com.betopia.hrm.services.hierarchyfilterservice.HierarchyFilterService;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class HierarchyFilterServiceImpl implements HierarchyFilterService {

    private final CompanyRepository companyRepository;
    private final BusinessUnitRepository businessUnitRepository;
    private final WorkplaceGroupRepository workplaceGroupRepository;
    private final WorkplaceRepository workplaceRepository;
    private final DepartmentRepository departmentRepository;
    private final TeamRepository teamRepository;
    private final HierarchyFilterMapper mapper;

    public HierarchyFilterServiceImpl(CompanyRepository companyRepository,
                                      BusinessUnitRepository businessUnitRepository,
                                      WorkplaceGroupRepository workplaceGroupRepository,
                                      WorkplaceRepository workplaceRepository,
                                      DepartmentRepository departmentRepository,
                                      TeamRepository teamRepository,
                                      HierarchyFilterMapper mapper) {
        this.companyRepository = companyRepository;
        this.businessUnitRepository = businessUnitRepository;
        this.workplaceGroupRepository = workplaceGroupRepository;
        this.workplaceRepository = workplaceRepository;
        this.departmentRepository = departmentRepository;
        this.teamRepository = teamRepository;
        this.mapper = mapper;
    }

    @Override
    public HierarchyFilterDTO getHierarchyFilterData(Long companyId,
                                               Long businessUnitId,
                                               Long workplaceGroupId,
                                               Long workplaceId,
                                               Long departmentId) {

        List<Company> companies = Collections.emptyList();
        List<BusinessUnit> businessUnits = Collections.emptyList();
        List<WorkplaceGroup> workplaceGroups = Collections.emptyList();
        List<Workplace> workplaces = Collections.emptyList();
        List<Department> departments = Collections.emptyList();
        List<Team> teams = Collections.emptyList();

        if (companyId == null && businessUnitId == null && workplaceGroupId == null
                && workplaceId == null && departmentId == null) {
            companies = companyRepository.findAll(Sort.by(Sort.Direction.ASC, "name"));
        }

        if (companyId != null && businessUnitId == null) {
            businessUnits = businessUnitRepository.findByCompanyIdOrderByIdDesc(companyId);
        }

        if (businessUnitId != null && workplaceGroupId == null) {
            workplaceGroups = workplaceGroupRepository.findByBusinessUnitIdOrderByIdDesc(businessUnitId);
        }

        if (workplaceGroupId != null && workplaceId == null) {
            workplaces = workplaceRepository.findByWorkplaceGroupIdOrderByIdDesc(workplaceGroupId);
        }

        if (workplaceId != null && departmentId == null) {
            departments = departmentRepository.findByWorkplaceIdOrderByIdDesc(workplaceId);
        }

        if (departmentId != null) {
            teams = teamRepository.findByDepartmentIdOrderByIdDesc(departmentId);
        }

        HierarchyFilterDTO hierarchyFilterDTO = new HierarchyFilterDTO(
                mapper.toCompanyDTOList(companies),
                mapper.toBusinessUnitDTOList(businessUnits),
                mapper.toWorkplaceGroupDTOList(workplaceGroups),
                mapper.toWorkplaceDTOList(workplaces),
                mapper.toDepartmentDTOList(departments),
                mapper.toTeamDTOList(teams)
        );

        return hierarchyFilterDTO;

    }
}
