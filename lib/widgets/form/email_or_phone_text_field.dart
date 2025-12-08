import 'package:flutter/material.dart';
import 'package:sham_cars/utils/utils.dart';

import '../custom_text_field.dart';

class EmailOrPhoneTextField extends StatelessWidget {
  const EmailOrPhoneTextField({
    super.key,
    required this.controller,
    required this.validator,
    this.enabled = true,
  });
  final TextEditingController controller;
  final String? Function(String?, BuildContext) validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      validator: (value) => validator(value, context),
      hintText: context.l10n.emailOrPhoneFieldHint,
      labelText: context.l10n.emailOrPhoneFieldLabel,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: enabled,
    );
  }
}
