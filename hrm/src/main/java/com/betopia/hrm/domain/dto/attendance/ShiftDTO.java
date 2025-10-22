package com.betopia.hrm.domain.dto.attendance;

import com.betopia.hrm.domain.dto.company.*;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@JsonInclude(JsonInclude.Include.ALWAYS)
public class ShiftDTO {

    private Long id;
    private ShiftCategoryDTO shiftCategory;
    private String shiftName;
    private String shiftCode;

    private CompanyDTO company;
    private BusinessUnitDTO businessUnit;
    private WorkplaceGroupDTO workPlaceGroup;
    private WorkplaceDTO workPlace;
    private DepartmentDTO department;
    private TeamDTO team;

    private LocalTime startTime;
    private LocalTime endTime;
    private Integer breakMinutes;
    private Boolean isNightShift;
    private Integer graceInMinutes;
    private Integer graceOutMinutes;
    private Boolean status;

    private List<ShiftWeeklyOffDTO> weeklyOffs;

    public ShiftDTO() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ShiftCategoryDTO getShiftCategory() {
        return shiftCategory;
    }

    public void setShiftCategory(ShiftCategoryDTO shiftCategory) {
        this.shiftCategory = shiftCategory;
    }

    public String getShiftName() {
        return shiftName;
    }

    public void setShiftName(String shiftName) {
        this.shiftName = shiftName;
    }

    public String getShiftCode() {
        return shiftCode;
    }

    public void setShiftCode(String shiftCode) {
        this.shiftCode = shiftCode;
    }

    public CompanyDTO getCompany() {
        return company;
    }

    public void setCompany(CompanyDTO company) {
        this.company = company;
    }

    public BusinessUnitDTO getBusinessUnit() {
        return businessUnit;
    }

    public void setBusinessUnit(BusinessUnitDTO businessUnit) {
        this.businessUnit = businessUnit;
    }

    public WorkplaceGroupDTO getWorkPlaceGroup() {
        return workPlaceGroup;
    }

    public void setWorkPlaceGroup(WorkplaceGroupDTO workPlaceGroup) {
        this.workPlaceGroup = workPlaceGroup;
    }

    public WorkplaceDTO getWorkPlace() {
        return workPlace;
    }

    public void setWorkPlace(WorkplaceDTO workPlace) {
        this.workPlace = workPlace;
    }

    public DepartmentDTO getDepartment() {
        return department;
    }

    public void setDepartment(DepartmentDTO department) {
        this.department = department;
    }

    public TeamDTO getTeam() {
        return team;
    }

    public void setTeam(TeamDTO team) {
        this.team = team;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public Integer getBreakMinutes() {
        return breakMinutes;
    }

    public void setBreakMinutes(Integer breakMinutes) {
        this.breakMinutes = breakMinutes;
    }

    public Boolean getNightShift() {
        return isNightShift;
    }

    public void setNightShift(Boolean nightShift) {
        isNightShift = nightShift;
    }

    public Integer getGraceInMinutes() {
        return graceInMinutes;
    }

    public void setGraceInMinutes(Integer graceInMinutes) {
        this.graceInMinutes = graceInMinutes;
    }

    public Integer getGraceOutMinutes() {
        return graceOutMinutes;
    }

    public void setGraceOutMinutes(Integer graceOutMinutes) {
        this.graceOutMinutes = graceOutMinutes;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public List<ShiftWeeklyOffDTO> getWeeklyOffs() {
        return weeklyOffs;
    }

    public void setWeeklyOffs(List<ShiftWeeklyOffDTO> weeklyOffs) {
        this.weeklyOffs = weeklyOffs;
    }
}
