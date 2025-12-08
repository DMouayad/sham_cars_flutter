import 'package:sham_cars/features/user/models.dart';

typedef StartSignupWithEmailRequest = ({Role role, String email});

typedef StartSignupWithPhoneRequest = ({Role role, String phoneNumber});

typedef ConfirmSignupWithEmailRequest = ({
  String signupCode,
  Role role,
  String email,
  String password,
});

typedef ConfirmSignupWithPhoneRequest = ({
  String signupCode,
  Role role,
  String phoneNumber,
  String password,
});

typedef LoginRequest = ({String emailOrPhone, String password});

typedef ConfirmIdentityRequest = ({String code});
