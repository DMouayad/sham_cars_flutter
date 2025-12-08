import 'package:flutter/material.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/custom_text_field.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.formHelper,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.isForCreatingPassword = false,
  });
  final BaseFormHelper formHelper;
  final TextInputAction textInputAction;
  final bool enabled;
  final bool isForCreatingPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          obscure: true,
          enabled: enabled,
          controller: formHelper.passwordController,
          validator: (value) => formHelper.passwordValidator(
            value,
            context,
            isNewPassword: isForCreatingPassword,
          ),
          labelText: context.l10n.passwordFieldLabel,
          textInputAction: textInputAction,
        ),
        if (isForCreatingPassword)
          _buildStrengthFeedback(context, isForCreatingPassword),
      ],
    );
  }

  Widget _buildStrengthFeedback(
    BuildContext context,
    bool isForCreatingPassword,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: formHelper.passwordController,
          builder: (context, value, _) {
            final password = value.text;
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  (isForCreatingPassword
                          ? formHelper.newPasswordValidators
                          : formHelper.passwordValidators)
                      .map(
                        (validator) => _buildValidationRule(
                          isValid: validator(password, context).isValid,
                          rule: validator(password, context).rule,
                        ),
                      )
                      .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildValidationRule({required bool isValid, required String rule}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isValid ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            rule,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.red,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
