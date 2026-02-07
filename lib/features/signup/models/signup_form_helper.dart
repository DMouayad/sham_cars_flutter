import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:sham_cars/api/config.dart';
import 'package:sham_cars/utils/src/validators.dart';
import 'package:sham_cars/utils/utils.dart';

class SignupFormHelper extends BaseFormHelper
    implements IPasswordConfirmationFormHelper {
  static final _translator = {'#': RegExp(r'[0-9]{0,3}')};
  static const kPhoneNumberMask = '0 9## ### ###';

  SignupFormHelper({String? phoneInitialValue, String? emailInitialValue})
    : phoneNoController = MaskedTextController(
        mask: kPhoneNumberMask,
        translator: _translator,
        text: phoneInitialValue,
      ),
      signupCodeDigits = {},
      passwordConfirmationController = TextEditingController(),
      nameController = TextEditingController(),
      super();
  final ValueNotifier<bool> signupCodeIsComplete = ValueNotifier(false);
  final Map<int, String> signupCodeDigits;
  String get signupCodeValue => signupCodeDigits.values.join();

  final TextEditingController phoneNoController;
  final TextEditingController nameController;
  @override
  final TextEditingController passwordConfirmationController;

  bool isMale = true;

  final showSignupCodeValidationErrorMsg = ValueNotifier(false);

  String get phoneNoValue => phoneNoController.text;
  String get nameValue => nameController.text;

  String? phoneNoValidator(String? value, BuildContext context) {
    if (value?.isEmpty ?? true) {
      return context.l10n.phoneNumberIsRequired;
    } else {
      if (!isValidPhoneNo(value)) {
        return context.l10n.phoneNumberIsInvalid;
      }
    }
    return null;
  }

  String? nameValidator(String? value, BuildContext context) {
    if (value?.isEmpty ?? true) {
      return context.l10n.nameIsRequired;
    }
    return null;
  }

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
  bool validateInput({bool validateSignupCode = false}) {
    showSignupCodeValidationErrorMsg.value =
        validateSignupCode && !_signupCodeIsValid();
    return super.validateInput() &&
        (validateSignupCode ? _signupCodeIsValid() : true);
  }

  bool _signupCodeIsValid() {
    return signupCodeValue.length == ApiConfig.signupCodeLength;
  }

  void updateSignupCodeDigit(int index, String value) {
    signupCodeDigits[index] = value;
    signupCodeIsComplete.value = _signupCodeIsValid();
    if (showSignupCodeValidationErrorMsg.value) {
      validateInput(validateSignupCode: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneNoController.dispose();
    passwordConfirmationController.dispose();
    nameController.dispose();
  }
}
