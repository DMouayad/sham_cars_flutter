typedef SignupRequest = ({
  String name,
  String email,
  String phone,
  String password,
});

typedef LoginRequest = ({String emailOrPhone, String password});

typedef VerifyAccountRequest = ({String email, String code});

typedef SendVerificationCodeRequest = ({String email});
