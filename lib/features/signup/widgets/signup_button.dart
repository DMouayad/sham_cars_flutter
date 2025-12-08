import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/utils/utils.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    return FilledButton(
      key: const Key('signup_raisedButton'),
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (cubit.state.isPendingConfirmation) {
          context.read<SignupCubit>().onConfirmSignup();
        } else {
          context.read<SignupCubit>().onStartSignup();
        }
      },
      style: const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
      ),
      child: Text(
        cubit.state.isPendingConfirmation
            ? context.l10n.completeSignupBtnLabel
            : context.l10n.continueBtnLabel,
      ),
    );
  }
}
