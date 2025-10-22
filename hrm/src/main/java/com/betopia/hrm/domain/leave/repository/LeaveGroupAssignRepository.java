package com.betopia.hrm.domain.leave.repository;

import com.betopia.hrm.domain.leave.entity.LeaveGroup;
import com.betopia.hrm.domain.leave.entity.LeaveGroupAssign;
import com.betopia.hrm.domain.leave.entity.LeaveType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface LeaveGroupAssignRepository extends JpaRepository<LeaveGroupAssign, Long> , JpaSpecificationExecutor<LeaveGroupAssign> {

    boolean existsByLeaveTypeAndLeaveGroup(LeaveType leaveType, LeaveGroup leaveGroup);

    boolean existsByLeaveTypeAndLeaveGroupAndIdNot(LeaveType leaveType, LeaveGroup leaveGroup, Long id);
}
