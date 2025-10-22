package com.betopia.hrm.services.auth;

import com.betopia.hrm.domain.auth.login.ForgetPasswordRequest;
import com.betopia.hrm.domain.auth.login.ResetPasswordRequestBody;

public interface PasswordResetService {

    ForgetPasswordRequest forgotPassword(ForgetPasswordRequest request);

    void resetPassword(ResetPasswordRequestBody request);
}
