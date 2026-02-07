import 'package:flutter/material.dart';
import 'package:sham_cars/utils/utils.dart';

class PasswordResetFormHelper extends BaseFormHelper
    implements IPasswordConfirmationFormHelper {
  PasswordResetFormHelper()
    : passwordConfirmationController = TextEditingController(),
      super();

  @override
  final TextEditingController passwordConfirmationController;
  String get confirmPasswordValue => passwordConfirmationController.text;

  @override
  String? passwordConfirmationValidator(String? value, BuildContext context) {
    if (value?.isEmpty ?? true) {
      return context.l10n.passwordConfirmationIsRequired;
    } else if (value != passwordValue) {
      return context.l10n.passwordConfirmationMismatch;
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    passwordConfirmationController.dispose();
  }
}
