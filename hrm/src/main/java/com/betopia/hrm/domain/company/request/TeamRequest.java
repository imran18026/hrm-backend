package com.betopia.hrm.domain.company.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record TeamRequest(
        Long id,

        @NotNull(message = "Department ID cannot be null")
        Long departmentId,

        @NotNull(message = "Name cannot be null")
        @NotBlank(message = "Name cannot be blank")
        String name,

        @NotNull(message = "Code cannot be null")
        @NotBlank(message = "Code cannot be blank")
        String code,

        @NotNull(message = "Description cannot be null")
        @NotBlank(message = "Description cannot be blank")
        String description,

        @NotNull(message = "Status cannot be null")
        Boolean status
) {
}
