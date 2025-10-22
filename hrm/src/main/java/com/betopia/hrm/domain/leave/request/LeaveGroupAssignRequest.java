package com.betopia.hrm.domain.leave.request;

import jakarta.validation.constraints.NotNull;

public record LeaveGroupAssignRequest(
        Long id,

        @NotNull(message = "leaveTypeId cannot be null")
        Long leaveTypeId,

        @NotNull(message = "leaveGroupId cannot be null")
        Long leaveGroupId,

        @NotNull(message = "companyId cannot be null")
        Long companyId,

        @NotNull(message = "businessUnitId cannot be null")
        Long businessUnitId,

        @NotNull(message = "workPlaceGroupId cannot be null")
        Long workPlaceGroupId,

        @NotNull(message = "workPlaceId cannot be null")
        Long workPlaceId,

        Long departmentId,

        Long teamId,

        @NotNull(message = "description cannot be null")
        String description,

        @NotNull(message = "status cannot be null")
        Boolean status
) {
}
