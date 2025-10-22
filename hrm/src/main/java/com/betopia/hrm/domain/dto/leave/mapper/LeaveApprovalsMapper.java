package com.betopia.hrm.domain.dto.leave.mapper;

import com.betopia.hrm.domain.dto.leave.LeaveApprovalsDTO;
import com.betopia.hrm.domain.leave.entity.LeaveApprovals;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface LeaveApprovalsMapper {

    LeaveApprovalsDTO toDTO(LeaveApprovals leaveApproval);

    // List mapping
    List<LeaveApprovalsDTO> toDTOList(List<LeaveApprovals> leaveApprovals);
}
