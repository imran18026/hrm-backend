package com.betopia.hrm.domain.dto.employee.mapper;

import com.betopia.hrm.domain.dto.employee.EmployeeDTO;
import com.betopia.hrm.domain.employee.entity.Employee;
import com.betopia.hrm.domain.lookup.entity.LookupSetupEntry; // Don't forget this import if used in toLookupDetailsDTO
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface EmployeeDTOMapper {

    @Mapping(source = "employeeType.id",   target = "employeeTypeId")
    @Mapping(source = "department.id",     target = "departmentId")
    @Mapping(source = "designation.id",    target = "designationId")
    @Mapping(source = "workplace.id",      target = "workplaceId")
    @Mapping(source = "businessUnit.id",   target = "businessUnitId")
    @Mapping(source = "workplaceGroup.id", target = "workplaceGroupId")
    @Mapping(source = "grade.id",          target = "gradeId")
    @Mapping(source = "company.id",        target = "companyId")
    @Mapping(source = "team.id",           target = "teamId")
    @Mapping(target = "grossSalary", source = "grossSalary")

    @Mapping(source = "religion", target = "religionId")
    @Mapping(source = "nationality", target = "nationalityId")
    @Mapping(source = "bloodGroup", target = "bloodGroupId")
    @Mapping(source = "paymentType", target = "paymentTypeId")
    @Mapping(source = "probationDuration", target = "probationDurationId")

    @Mapping(target = "displayName", expression = "java(concatenateNames(employee.getFirstName(), employee.getLastName()))")


    EmployeeDTO toDTO(Employee employee);
    List<EmployeeDTO> toDTOList(List<Employee> employees);

    default String concatenateNames(String firstName, String lastName) {
        StringBuilder displayNameBuilder = new StringBuilder();
        if (firstName != null && !firstName.trim().isEmpty()) {
            displayNameBuilder.append(firstName.trim());
        }
        if (lastName != null && !lastName.trim().isEmpty()) {
            if (displayNameBuilder.length() > 0) {
                displayNameBuilder.append(" ");
            }
            displayNameBuilder.append(lastName.trim());
        }
        return displayNameBuilder.length() > 0 ? displayNameBuilder.toString() : null;
    }
}
