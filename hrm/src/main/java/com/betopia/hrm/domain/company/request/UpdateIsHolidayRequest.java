package com.betopia.hrm.domain.company.request;

public record UpdateIsHolidayRequest(
        Long id,
        Boolean isHoliday
) {
}
