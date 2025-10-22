package com.betopia.hrm.domain.employee.repository;

import com.betopia.hrm.domain.employee.entity.Designation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DesignationRepository extends JpaRepository<Designation, Long> {
}
