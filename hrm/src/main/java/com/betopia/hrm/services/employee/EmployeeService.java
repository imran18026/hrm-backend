package com.betopia.hrm.services.employee;

import com.betopia.hrm.domain.base.response.pagination.PaginationResponse;
import com.betopia.hrm.domain.dto.employee.EmployeeDTO;
import com.betopia.hrm.domain.employee.entity.Employee;
import com.betopia.hrm.domain.employee.request.EmployeeRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.List;

public interface EmployeeService {

    PaginationResponse<EmployeeDTO> index(Sort.Direction direction, int page, int perPage);

    PaginationResponse<EmployeeDTO> searchEmployees(Long departmentId,
                                   Long designationId,
                                   Long workplaceId,
                                   Long workPlaceGroupId,
                                   Long companyId,
                                   Long gradeId,
                                   Long employeeTypeId,
                                   String employeeName,
                                   Pageable pageable);

    List<EmployeeDTO> getAllEmployees();

    EmployeeDTO store(EmployeeRequest request);

    EmployeeDTO show(Long employeeId);

    EmployeeDTO update(Long employeeId, EmployeeRequest request);

    void delete(Long employeeId);

    Long findReportingManagerId(Long employeeId);
}
