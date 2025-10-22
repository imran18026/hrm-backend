package com.betopia.hrm.controllers.rest.v1.employee;

import com.betopia.hrm.domain.base.response.GlobalResponse;
import com.betopia.hrm.domain.base.response.pagination.PaginationResponse;
import com.betopia.hrm.domain.dto.employee.EmployeeDTO;
import com.betopia.hrm.domain.employee.request.EmployeeRequest;
import com.betopia.hrm.services.employee.EmployeeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 6000)
@RestController
@RequestMapping("/v1/employees")
@Tag(
        name = "Employee Management -> Employee setup",
        description = "APIs for configurable employee. Includes operations to create, read, update, and delete employee."
)
public class EmployeeController {

    private final EmployeeService employeeService;

    public EmployeeController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    @GetMapping
    @Operation(
            summary = "1. Get paginated list of employee",
            description = "Retrieves a paginated list of employee from the system. "
                    + "Supports parameters such as page number and page size to control the result set. "
                    + "Use this endpoint when you want to fetch employee records in a paginated format instead of retrieving all at once."
    )
    public ResponseEntity<PaginationResponse<EmployeeDTO>> index(
            @RequestParam(defaultValue = "DESC") String sortDirection,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int perPage
    ){
        Sort.Direction direction = Sort.Direction.fromString(sortDirection.toUpperCase());

        PaginationResponse<EmployeeDTO> paginationResponse = employeeService.index(direction, page, perPage);

        return ResponseEntity.ok(paginationResponse);
    }

    @GetMapping("/all")
    @Operation(
            summary = "2. Get all employee",
            description = "Retrieves a list of all employees available in the system. "
                    + "This endpoint returns the complete employee collection without pagination. "
    )
    public ResponseEntity<GlobalResponse> getAllEmployeeTypes()
    {
        List<EmployeeDTO> employees = employeeService.getAllEmployees();

        GlobalResponse response = GlobalResponse.success(
                employees,
                "All employees fetch successful",
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    @PostMapping
    @Operation(
            summary = "3. Create a new employee",
            description = "Creates a new emploee in the system with the provided details. "
                    + "Required fields such aa name,date of joining,department,supervisor,designation must be included in the request body. "
                    + "Returns the created employee along with its unique ID."
    )
    public ResponseEntity<GlobalResponse> store(@Valid @RequestBody EmployeeRequest request)
    {
        EmployeeDTO employee = employeeService.store(request);

        GlobalResponse response = GlobalResponse.success(
                employee,
                "Insert successfully",
                HttpStatus.CREATED.value()
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("{id}")
    @Operation(
            summary = "4. Get employee by ID",
            description = "Retrieves the details of a specific employee using the provided ID. "
                    + "If the employee with the given ID does not exist, a 404 Not Found response will be returned."
    )
    public ResponseEntity<GlobalResponse> show(@PathVariable("id") Long employeeId)
    {
        EmployeeDTO employee = employeeService.show(employeeId);
          System.out.println(employee.getGrossSalary());
        GlobalResponse response = GlobalResponse.success(
                employee,
                "Employee fetch successful",
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    @PutMapping("{id}")
    @Operation(
            summary = "5. Update employee by ID",
            description = "Updates the details of an existing employee using the provided ID. "
                    + "This endpoint allows modifying employee name,designation,supervisor or other attributes. "
                    + "If the employee with the given ID does not exist, a 404 Not Found response will be returned."
    )
    public ResponseEntity<GlobalResponse> update(@PathVariable("id") Long employeeId,
                                                 @Valid @RequestBody EmployeeRequest request)
    {
        EmployeeDTO employee = employeeService.update(employeeId, request);

        GlobalResponse response = GlobalResponse.success(
                employee,
                "Update successful",
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    @DeleteMapping("{id}")
    @Operation(
            summary = "6. Delete employee by ID",
            description = "Deletes a specific employee from the system using the provided ID. "
                    + "If the employee does not exist, a 404 Not Found response will be returned. "
                    + "Use this endpoint to permanently remove employee records."
    )
    public ResponseEntity<GlobalResponse> destroy(@PathVariable("id") Long employeeId)
    {
        employeeService.delete(employeeId);

        GlobalResponse response = GlobalResponse.success(
                null,
                "Employee deleted successfully",
                HttpStatus.NO_CONTENT.value()
        );

        return ResponseEntity.status(HttpStatus.NO_CONTENT).body(response);
    }

    @Operation(
            summary = "1. Get paginated list of searching employee using parameter name and all reference attribute of employee",
            description = "Retrieves a paginated list of employee from the system. "
                    + "Supports parameters such as page number and page size to control the result set. "
                    + "Use this endpoint when you want to fetch employee records in a paginated format instead of retrieving all at once."
    )
    @GetMapping("/searchEmployee")
    public ResponseEntity<PaginationResponse<EmployeeDTO>> searchEmployees(
            @RequestParam(required = false) Long departmentId,
            @RequestParam(required = false) Long designationId,
            @RequestParam(required = false) Long workplaceId,
            @RequestParam(required = false) Long workPlaceGroupId,
            @RequestParam(required = false) Long companyId,
            @RequestParam(required = false) Long gradeId,
            @RequestParam(required = false) Long employeeTypeId,
            @RequestParam(required = false) String employeeName,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int perPage
    ) {

        PaginationResponse<EmployeeDTO> paginationResponse =  employeeService.searchEmployees(departmentId, designationId, workplaceId, workPlaceGroupId,
                companyId, gradeId, employeeTypeId, employeeName,PageRequest.of(page, perPage));
        return ResponseEntity.ok(paginationResponse);

    }

}
