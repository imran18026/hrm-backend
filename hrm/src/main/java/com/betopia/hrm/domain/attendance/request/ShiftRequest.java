package com.betopia.hrm.domain.attendance.request;

import com.betopia.hrm.domain.attendance.entity.ShiftCategory;
import com.betopia.hrm.domain.company.entity.BusinessUnit;
import com.betopia.hrm.domain.company.entity.Department;
import com.betopia.hrm.domain.company.entity.Team;
import com.betopia.hrm.domain.company.entity.WorkplaceGroup;
import com.betopia.hrm.domain.users.entity.Company;
import com.betopia.hrm.domain.users.entity.Workplace;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Size;

import java.time.LocalTime;
import java.util.List;

public record ShiftRequest(

        @NotBlank(message = "Shift name is required")
        @Size(max = 100, message = "Shift name cannot exceed 100 characters")
        String shiftName,

        @NotBlank(message = "Shift code is required")
        @Size(max = 50, message = "Shift code cannot exceed 50 characters")
        String shiftCode,

        Long shiftCategoryId,

        Long companyId,

        Long businessUnitId,

        Long workPlaceGroupId,

        Long workPlaceId,

        Long departmentId,

        Long teamId,

        @NotNull(message = "Start time is required")
        LocalTime startTime,

        @NotNull(message = "End time is required")
        LocalTime endTime,

        @PositiveOrZero(message = "Break minutes must be zero or positive")
        Integer breakMinutes,

        @NotNull(message = "Night shift flag is required")
        Boolean isNightShift,

        @PositiveOrZero(message = "Grace in minutes must be zero or positive")
        Integer graceInMinutes,

        @PositiveOrZero(message = "Grace out minutes must be zero or positive")
        Integer graceOutMinutes,

        @NotNull(message = "Status is required")
        Boolean status,

        @Valid
        List<WeeklyOffRequest> weeklyOffs
) {
    public record WeeklyOffRequest(
            Long id,

            @NotBlank(message = "Day of week is required")
            String dayOfWeek
    ) {}
}
