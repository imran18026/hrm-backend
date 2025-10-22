package com.betopia.hrm.domain.company.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record BusinessUnitRequest(

    @NotNull(message = "Company ID cannot be null")
    @Positive(message = "Company ID must be positive")
    Long company,

    @NotBlank(message = "Name cannot be blank")
    @NotNull(message = "Name cannot be null")
    String name,


    String code,
    String description,
    Boolean status
) {
}
