import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/features/signup/models/signup_method.dart';
import 'package:sham_cars/utils/utils.dart';

class SwitchSignupMethodButton extends StatelessWidget {
  const SwitchSignupMethodButton({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignupCubit>().state;
    return TextButton(
      onPressed: () {
        final newMethod = state.method.isEmail
            ? SignupMethod.phone
            : SignupMethod.email;

        context.read<SignupCubit>().switchSignupMethod(newMethod);
      },
      child: Text(
        state.method.isEmail
            ? context.l10n.signupWithPhone
            : context.l10n.signupWithEmail,
      ),
    );
  }
}
