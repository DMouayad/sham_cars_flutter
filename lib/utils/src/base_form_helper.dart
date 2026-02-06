part of '../utils.dart';

typedef PasswordValidationRule = ({String rule, bool isValid});
typedef PasswordValidator =
    PasswordValidationRule Function(String value, BuildContext context);

abstract class BaseFormHelper {
  BaseFormHelper() {
    formKey = GlobalKey();

    passwordController = TextEditingController();
    emailController = TextEditingController();
  }

  late final GlobalKey<FormState> formKey;

  late final TextEditingController emailController;
  String get emailValue => emailController.text;
  String? emailValidator(String? value, BuildContext context) {
    if (value?.isEmpty ?? true) {
      return context.l10n.emailIsRequired;
    } else {
      if (!isValidEmail(value)) {
        return context.l10n.emailIsInvalid;
      }
    }
    return null;
  }

  late final TextEditingController passwordController;

  String get passwordValue => passwordController.value.text.trim();

  List<PasswordValidator> get passwordValidators => [
    (password, context) =>
        (rule: context.l10n.passwordRuleLength, isValid: password.isNotEmpty),
  ];
  List<PasswordValidator> get newPasswordValidators => [
    (password, context) =>
        (rule: context.l10n.passwordRuleLength, isValid: password.length >= 8),
    (password, context) => (
      rule: context.l10n.passwordRuleUppercase,
      isValid: password.contains(RegExp(r'[A-Z]')),
    ),
    (password, context) => (
      rule: context.l10n.passwordRuleNumber,
      isValid: password.contains(RegExp(r'[0-9]')),
    ),
  ];

  String? passwordValidator(
    String? password,
    BuildContext context, {
    bool isNewPassword = false,
  }) {
    if (password?.trim().isEmpty ?? true) {
      return context.l10n.passwordIsRequired;
    } else if (!_isValidPassword(password!, context, isNewPassword)) {
      return '';
    }
    return null;
  }

  bool _isValidPassword(
    String value,
    BuildContext context,
    bool isNewPassword,
  ) {
    return (isNewPassword ? newPasswordValidators : passwordValidators).every(
      (validator) => validator(value, context).isValid,
    );
  }

  void saveFormState() => formKey.currentState?.save();
  bool validateInput() {
    saveFormState();
    return formKey.currentState?.validate() ?? false;
  }

  @mustCallSuper
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
  }
}
