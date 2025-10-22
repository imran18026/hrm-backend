package com.betopia.hrm.domain.leave.specification;

import com.betopia.hrm.domain.employee.entity.Employee;
import com.betopia.hrm.domain.leave.entity.LeaveGroupAssign;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;


public class LeaveGroupAssignSpecification {

    public static Specification<LeaveGroupAssign> applicableForEmployee(Employee employee) {
        Long companyId = employee.getCompany() != null ? employee.getCompany().getId() : null;
        Long businessUnitId = employee.getBusinessUnit() != null ? employee.getBusinessUnit().getId() : null;
        Long workplaceGroupId = employee.getWorkplaceGroup() != null ? employee.getWorkplaceGroup().getId() : null;
        Long workplaceId = employee.getWorkplace() != null ? employee.getWorkplace().getId() : null;
        Long teamId = employee.getTeam() != null ? employee.getTeam().getId() : null;

        return (root, query, cb) -> {
            Predicate companyMatch = cb.equal(root.get("company").get("id"), companyId);

            Predicate businessUnitMatch = cb.or(
                    cb.isNull(root.get("businessUnit")),
                    cb.equal(root.get("businessUnit").get("id"), businessUnitId)
            );

            Predicate workplaceGroupMatch = cb.or(
                    cb.isNull(root.get("workplaceGroup")),
                    cb.equal(root.get("workplaceGroup").get("id"), workplaceGroupId)
            );

            Predicate workplaceMatch = cb.or(
                    cb.isNull(root.get("workplace")),
                    cb.equal(root.get("workplace").get("id"), workplaceId)
            );

            Predicate teamMatch = cb.or(
                    cb.isNull(root.get("team")),
                    cb.equal(root.get("team").get("id"), teamId)
            );

            // Order by specificity: the more fields filled, the higher priority
            query.orderBy(
                    cb.desc(cb.selectCase()
                            .when(cb.isNotNull(root.get("team")), 5)
                            .when(cb.isNotNull(root.get("workplace")), 4)
                            .when(cb.isNotNull(root.get("workplaceGroup")), 3)
                            .when(cb.isNotNull(root.get("businessUnit")), 2)
                            .otherwise(1))
            );

            return cb.and(companyMatch, businessUnitMatch, workplaceGroupMatch,
                          workplaceMatch, teamMatch);
        };
    }
}
