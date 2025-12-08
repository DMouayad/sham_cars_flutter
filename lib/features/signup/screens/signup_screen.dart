import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/signup/widgets/signup_form.dart';

import 'package:sham_cars/features/user/models/role.dart';
import 'package:sham_cars/routes/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/custom_scaffold.dart';
import 'package:sham_cars/widgets/no_pop_wrapper.dart';

import '../cubit/signup_cubit.dart';
import '../models/signup_method.dart';
import 'signup_confirmation_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({required this.signupAs, super.key, required this.method});
  final Role signupAs;
  final SignupMethod method;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(signupAs: signupAs, method: method),
      lazy: false,
      child: BlocListener<SignupCubit, SignupState>(
        listenWhen: (prev, current) =>
            prev.hasException != current.hasException ||
            prev.isSuccess != current.isSuccess,
        listener: (context, state) {
          if (state.hasException) {
            showErrorDialog(
              context,
              title: context.l10n.signupFailureDialogTitle,
              errMessage: state.appErr?.getMessage(context),
            );
          } else if (state.isSuccess) {
            const UserProfileScreenRoute().pushReplacement(context);
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
          prev.isBusy != current.isBusy ||
          prev.isPendingConfirmation != current.isPendingConfirmation,
      builder: (context, state) {
        return NoPopWrapper(
          dialogTitle: context.l10n.popConfirmationDialogTitle,
          dialogMessage: context.l10n.confirmExitingSignupDialogMessage,
          goBackBtnLabel: context.l10n.exitSignupProcessBtnLabel,
          stayOnPageBtnLabel: context.l10n.continueSignupBtnLabel,
          child: CustomScaffold(
            title: getTitle(context),
            showOptionsActionBtn: true,
            body: state.isPendingConfirmation
                ? const SignupConfirmationScreen()
                : const SignupForm(),
            showLoadingBarrier: state.isBusy,
            loadingBarrierText: state.isPendingConfirmation
                ? context.l10n.signupInProgress
                : context.l10n.sendingSignupCodeInProgress,
          ),
        );
      },
    );
  }

  String getTitle(BuildContext context) {
    final state = context.read<SignupCubit>().state;

    return switch (state.role) {
      Role.patient => context.l10n.signupAsPatientScreenTitle,
      Role.physician => context.l10n.signupAsDoctorScreenTitle,
      Role.guest => throw UnimplementedError(),
    };
  }
}
