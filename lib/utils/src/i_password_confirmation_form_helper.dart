part of '../utils.dart';

abstract class IPasswordConfirmationFormHelper extends BaseFormHelper {
  TextEditingController get passwordConfirmationController;
  String? passwordConfirmationValidator(String? value, BuildContext context);
}
