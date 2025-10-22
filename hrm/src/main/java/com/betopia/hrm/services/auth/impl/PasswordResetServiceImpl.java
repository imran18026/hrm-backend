package com.betopia.hrm.services.auth.impl;

import com.betopia.hrm.domain.auth.login.ResetPassword;
import com.betopia.hrm.domain.auth.login.ForgetPasswordRequest;
import com.betopia.hrm.domain.auth.login.ResetPasswordRequestBody;
import com.betopia.hrm.domain.auth.login.repository.ResetPasswordRepository;
import com.betopia.hrm.domain.users.entity.User;
import com.betopia.hrm.domain.users.repository.UserRepository;
import com.betopia.hrm.services.auth.PasswordResetService;
import com.betopia.hrm.webapp.util.NotificationSender;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
public class PasswordResetServiceImpl implements PasswordResetService {

    @Value("${app.disable.email}")
    private boolean disableEmailService;

    private final UserRepository userRepository;
    private final ResetPasswordRepository resetPasswordRepository;
    private final TemplateEngine templateEngine;
    private final PasswordEncoder passwordEncoder;
    private final NotificationSender notificationSender;


    private static final String RESET_PASSWORD_URL = "https://hrm-solutions.betopiagroup.com/auth/reset-password";

    public PasswordResetServiceImpl(UserRepository userRepository, ResetPasswordRepository resetPasswordRepository, TemplateEngine templateEngine
    ,PasswordEncoder passwordEncoder,NotificationSender notificationSender ) {
        this.userRepository = userRepository;
        this.resetPasswordRepository = resetPasswordRepository;
        this.templateEngine = templateEngine;
        this.passwordEncoder = passwordEncoder;
        this.notificationSender = notificationSender;
    }

    @Override
    @Transactional
    public ForgetPasswordRequest forgotPassword(ForgetPasswordRequest request) {
        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new RuntimeException("User not found with email: " + request.email()));

        String token = UUID.randomUUID().toString();
        LocalDateTime createdAt = LocalDateTime.now();
        LocalDateTime updatedAt = LocalDateTime.now();
        LocalDateTime expiresAt = createdAt.plusHours(1);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy hh:mm a");
        String expiresAtFormatted = expiresAt.format(formatter);

        System.out.println("Expires at: " + expiresAtFormatted);


        ResetPassword resetPassword = new ResetPassword();
        resetPassword.setEmail(user.getEmail());
        resetPassword.setToken(token);
        resetPassword.setCreatedDate(createdAt);
        resetPassword.setLastModifiedDate(updatedAt);
        resetPassword.setExpiresAt(expiresAt);
        resetPasswordRepository.save(resetPassword);

        // Prepare Thymeleaf email body
        Context context = new Context();
        context.setVariable("resetUrl", RESET_PASSWORD_URL + token);
        context.setVariable("expiresAtFormatted", expiresAtFormatted);

        String emailBody = templateEngine.process("email", context);

        // Call NotificationSender
        if (!disableEmailService) {
            notificationSender.sendEmail(user.getEmail(), "Reset Your Password", emailBody);
        }

        return new ForgetPasswordRequest(
                request.id(),
                user.getEmail(),
                token,
                createdAt,
                updatedAt,
                expiresAt
        );
    }


    @Override
    @Transactional
    public void resetPassword(ResetPasswordRequestBody request) {
        // 1. Validate token exists
        ResetPassword resetToken = resetPasswordRepository.findByToken(request.token())
                .orElseThrow(() -> new RuntimeException("Invalid reset token"));

        // 2. Check token expiry
        if (resetToken.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Reset token has expired");
        }

        // 3. Match new password and confirm password
        if (!request.newPassword().equals(request.confirmPassword())) {
            throw new RuntimeException("New password and confirm password do not match");
        }

        // 4. Find user and update password
        User user = userRepository.findByEmail(resetToken.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setPassword(passwordEncoder.encode(request.newPassword()));
        userRepository.save(user);

        // 5. Delete the reset token entry
        resetPasswordRepository.delete(resetToken);
    }

    }





