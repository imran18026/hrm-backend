package com.betopia.hrm.webapp.config;

import com.betopia.hrm.domain.base.entity.Username;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import java.util.Optional;


@Configuration
@EnableJpaAuditing
@EnableTransactionManagement
public class JpaConfig {

    @Bean
    public AuditorAware<Long> auditor() {
//        return () -> Optional.ofNullable(SecurityContextHolder.getContext())
//                .map(SecurityContext::getAuthentication)
//                .filter(Authentication::isAuthenticated)
//                .map(Authentication::getPrincipal)
//                .map(UserDetails.class::cast)
//                .map(u -> new Username(u.getUsername()));

        return () -> Optional.of(1l); // Default auditor for simplicity
    }
}
