import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/utils/utils.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: const Key('signup_raisedButton'),
      onPressed: () {
        FocusScope.of(context).unfocus();
        context.read<SignupCubit>().signup();
      },
      style: const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
      ),
      child: Text(context.l10n.signupBtnLabel),
    );
  }
}
