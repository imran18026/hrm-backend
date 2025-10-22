package com.betopia.hrm.domain.leave.request;

import com.betopia.hrm.domain.leave.enums.LeaveStatus;
public record StatusApproveRequest(

        LeaveStatus leaveStatus,
        String remarks
) {
}
