package com.betopia.hrm.domain.attendance.entity;

import com.betopia.hrm.domain.attendance.enums.AdjustmentType;
import com.betopia.hrm.domain.attendance.enums.AttendanceStatus;
import com.betopia.hrm.domain.attendance.enums.SourceChannel;
import com.betopia.hrm.domain.base.entity.Auditable;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "manual_attendance")
public class ManualAttendance extends Auditable<Long, Long> {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "company_id", nullable = false)
    private Long company;

    @Column(name = "employee_id", nullable = false)
    private Long employee;

    @Column(name = "attendance_date", nullable = false)
    private LocalDate attendanceDate;

    @Column(name = "in_time")
    private LocalTime inTime;

    @Column(name = "out_time")
    private LocalTime outTime;

    @Enumerated(EnumType.STRING)
    @Column(name = "adjustment_type", nullable = false)
    private AdjustmentType adjustmentType;

    @Column(name = "reason", nullable = false)
    private String reason;

    @Enumerated(EnumType.STRING)
    @Column(name = "attendance_status", nullable = false)
    private AttendanceStatus attendanceStatus;

    @Column(name = "submitted_by", nullable = false)
    private Long submittedBy;

    @Column(name = "submitted_at")
    private LocalDateTime submittedAt = LocalDateTime.now();

    @Column(name = "reviewed_by")
    private Long reviewedBy;

    @Column(name = "reviewed_at")
    private LocalDateTime reviewedAt;

    @Column(name = "review_comment")
    private String reviewComment;

    @Enumerated(EnumType.STRING)
    @Column(name = "source_channel")
    private SourceChannel sourceChannel;

    @Column(name = "shift_id")
    private Long shift;

    @Column(name = "policy_version_id")
    private Long policyVersionId;

    @Column(name = "is_locked")
    private Boolean isLocked;

    // Getters and Setters
    public Long getCompany() { return company; }
    public void setCompany(Long company) { this.company = company; }

    public Long getEmployee() { return employee; }
    public void setEmployee(Long employee) { this.employee = employee; }

    public LocalDate getAttendanceDate() { return attendanceDate; }
    public void setAttendanceDate(LocalDate attendanceDate) { this.attendanceDate = attendanceDate; }

    public LocalTime getInTime() { return inTime; }
    public void setInTime(LocalTime inTime) { this.inTime = inTime; }

    public LocalTime getOutTime() { return outTime; }
    public void setOutTime(LocalTime outTime) { this.outTime = outTime; }

    public AdjustmentType getAdjustmentType() { return adjustmentType; }
    public void setAdjustmentType(AdjustmentType adjustmentType) { this.adjustmentType = adjustmentType; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public AttendanceStatus getStatus() { return attendanceStatus; }
    public void setStatus(AttendanceStatus attendanceStatus) { this.attendanceStatus = attendanceStatus; }

    public Long getSubmittedBy() { return submittedBy; }
    public void setSubmittedBy(Long submittedBy) { this.submittedBy = submittedBy; }

    public LocalDateTime getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(LocalDateTime submittedAt) { this.submittedAt = submittedAt; }

    public Long getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Long reviewedBy) { this.reviewedBy = reviewedBy; }

    public LocalDateTime getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }

    public String getReviewComment() { return reviewComment; }
    public void setReviewComment(String reviewComment) { this.reviewComment = reviewComment; }

    public SourceChannel getSourceChannel() { return sourceChannel; }
    public void setSourceChannel(SourceChannel sourceChannel) { this.sourceChannel = sourceChannel; }

    public Long getShift() { return shift; }
    public void setShift(Long shift) { this.shift = shift; }

    public Long getPolicyVersionId() { return policyVersionId; }
    public void setPolicyVersionId(Long policyVersionId) { this.policyVersionId = policyVersionId; }

    public Boolean getIsLocked() { return isLocked; }
    public void setIsLocked(Boolean isLocked) { this.isLocked = isLocked; }
}
