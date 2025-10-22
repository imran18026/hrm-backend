package com.betopia.hrm.domain.dto.leave.mapper;

import com.betopia.hrm.domain.dto.leave.LeaveGroupAssignDTO;
import com.betopia.hrm.domain.dto.leave.LeaveRequestDTO;
import com.betopia.hrm.domain.dto.leave.LeaveTypeDTO;
import com.betopia.hrm.domain.leave.entity.LeaveGroupAssign;
import com.betopia.hrm.domain.leave.entity.LeaveRequest;
import com.betopia.hrm.domain.leave.entity.LeaveType;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface LeaveRequestMapper {

    @Mapping(source = "leaveType", target = "leaveType", qualifiedByName = "toLeaveTypeDTO")
    @Mapping(source = "leaveGroupAssign", target = "leaveGroupAssign", qualifiedByName = "toLeaveGroupAssignDTO")
    LeaveRequestDTO toDTO(LeaveRequest entity);

    @Named("toLeaveTypeDTO")
    default LeaveTypeDTO toLeaveTypeDTO(LeaveType leaveType) {
        if (leaveType == null) {
            return null;
        }
        LeaveTypeDTO dto = new LeaveTypeDTO();
        dto.setId(leaveType.getId());
        dto.setName(leaveType.getName());
        return dto;
    }

    @Named("toLeaveGroupAssignDTO")
    default LeaveGroupAssignDTO toLeaveGroupAssignDTO(LeaveGroupAssign leaveGroupAssign) {
        if (leaveGroupAssign == null) {
            return null;
        }
        LeaveGroupAssignDTO dto = new LeaveGroupAssignDTO();
        dto.setId(leaveGroupAssign.getId());
        return dto;
    }
}
