package com.betopia.hrm.domain.attendance.entity;

import com.betopia.hrm.domain.base.entity.Auditable;
import com.betopia.hrm.domain.company.entity.BusinessUnit;
import com.betopia.hrm.domain.company.entity.Department;
import com.betopia.hrm.domain.company.entity.Team;
import com.betopia.hrm.domain.company.entity.WorkplaceGroup;
import com.betopia.hrm.domain.users.entity.Company;
import com.betopia.hrm.domain.users.entity.Workplace;
import jakarta.persistence.*;

import java.time.LocalTime;
import java.util.List;

@Entity
@Table(name = "shifts")
public class Shift extends Auditable<Long, Long> {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shift_category_id")
    private ShiftCategory shiftCategory;

    @Column(name = "shift_name", nullable = false, length = 100)
    private String shiftName;

    @Column(name = "shift_code", nullable = false, unique = true, length = 50)
    private String shiftCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "business_unit_id")
    private BusinessUnit businessUnit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "work_place_group_id")
    private WorkplaceGroup workPlaceGroup;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "work_place_id")
    private Workplace workPlace;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id")
    private Department department;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "team_id")
    private Team team;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @Column(name = "break_minutes")
    private Integer breakMinutes = 0;

    @Column(name = "is_night_shift")
    private Boolean isNightShift = false;

    @Column(name = "grace_in_minutes")
    private Integer graceInMinutes = 0;

    @Column(name = "grace_out_minutes")
    private Integer graceOutMinutes = 0;

    @Column(name = "status")
    private Boolean status = true;

    @OneToMany(mappedBy = "shift", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ShiftWeeklyOff> weeklyOffs;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ShiftCategory getShiftCategory() {
        return shiftCategory;
    }

    public void setShiftCategory(ShiftCategory shiftCategory) {
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

    public Company getCompany() {
        return company;
    }

    public void setCompany(Company company) {
        this.company = company;
    }

    public BusinessUnit getBusinessUnit() {
        return businessUnit;
    }

    public void setBusinessUnit(BusinessUnit businessUnit) {
        this.businessUnit = businessUnit;
    }

    public WorkplaceGroup getWorkPlaceGroup() {
        return workPlaceGroup;
    }

    public void setWorkPlaceGroup(WorkplaceGroup workPlaceGroup) {
        this.workPlaceGroup = workPlaceGroup;
    }

    public Workplace getWorkPlace() {
        return workPlace;
    }

    public void setWorkPlace(Workplace workPlace) {
        this.workPlace = workPlace;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Team getTeam() {
        return team;
    }

    public void setTeam(Team team) {
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

    public List<ShiftWeeklyOff> getWeeklyOffs() {
        return weeklyOffs;
    }

    public void setWeeklyOffs(List<ShiftWeeklyOff> weeklyOffs) {
        this.weeklyOffs = weeklyOffs;
        if (weeklyOffs != null) {
            weeklyOffs.forEach(off -> off.setShift(this));
        }
    }
}
