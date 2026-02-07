import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/custom_text_field.dart';

class PasswordConfirmationTextField extends StatelessWidget {
  const PasswordConfirmationTextField({
    super.key,
    required this.formHelper,
    this.enabled = true,
  });
  final IPasswordConfirmationFormHelper formHelper;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      key: const Key('signupForm_PasswordConfirmation_textField'),
      obscure: true,
      enabled: enabled,
      controller: formHelper.passwordConfirmationController,
      validator: (value) =>
          formHelper.passwordConfirmationValidator(value, context),
      hintText: context.l10n.passwordConfirmationFieldHint,
      labelText: context.l10n.passwordConfirmationFieldLabel,
      textInputAction: TextInputAction.done,
    );
  }
}

class _GenderInput extends StatefulWidget {
  const _GenderInput();

  @override
  State<_GenderInput> createState() => _GenderInputState();
}

class _GenderInputState extends State<_GenderInput> {
  bool isMale = true;
  @override
  Widget build(BuildContext context) {
    final formHelper = context.read<SignupCubit>().formHelper;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.l10n.genderInputTitle),
          ChoiceChip(
            label: Text(context.l10n.maleGender),
            selected: isMale,
            padding: const EdgeInsets.all(13),
            onSelected: (value) {
              setState(() => isMale = value);
              formHelper.isMale = isMale;
            },
          ),
          ChoiceChip(
            label: Text(context.l10n.femaleGender),
            selected: !isMale,
            padding: const EdgeInsets.all(13),
            onSelected: (value) {
              setState(() => isMale = !value);
              formHelper.isMale = isMale;
            },
          ),
        ],
      ),
    );
  }
}
