import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sham_cars/features/signup/widgets/signup_form.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/no_pop_wrapper.dart';
import 'package:sham_cars/widgets/page_loader.dart';

import 'signup_confirmation_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      lazy: false,
      child: BlocListener<SignupCubit, SignupState>(
        listenWhen: (prev, current) =>
            prev.hasException != current.hasException ||
            prev.isSuccess != current.isSuccess,
        listener: (context, state) {
          if (state.isBusy) {
            context.showLoader(
              message: state.isPendingVerification
                  ? context.l10n.signupInProgress
                  : context.l10n.sendingSignupCodeInProgress,
            );
          } else {
            context.hideLoader();
          }
          if (state.hasException) {
            showErrorDialog(
              context,
              title: context.l10n.signupFailureDialogTitle,
              errMessage: state.appErr?.getMessage(context),
            );
          } else if (state.isSuccess) {
            const ProfileRoute().pushReplacement(context);
          }
        },
        child: const _SignupScreenContent(),
      ),
    );
  }
}

class _SignupScreenContent extends StatelessWidget {
  const _SignupScreenContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (prev, current) =>
          prev.isPendingVerification != current.isPendingVerification,
      builder: (context, state) {
        return NoPopWrapper(
          dialogTitle: context.l10n.popConfirmationDialogTitle,
          dialogMessage: context.l10n.confirmExitingSignupDialogMessage,
          goBackBtnLabel: context.l10n.exitSignupProcessBtnLabel,
          stayOnPageBtnLabel: context.l10n.continueSignupBtnLabel,
          child: state.isPendingVerification
              ? const SignupConfirmationScreen()
              : const SignupForm(),
        );
      },
    );
  }
}
