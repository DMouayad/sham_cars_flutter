import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:sham_cars/features/password-reset/cubits/otp_password_reset_cubit.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/widgets/custom_scaffold.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/no_pop_wrapper.dart';
import 'package:sham_cars/widgets/otp_fields.dart';
import 'package:sham_cars/widgets/page_loader.dart';
import 'package:sham_cars/utils/utils.dart'; // For context.l10n, context.screenWidth, etc.

class OtpPasswordResetScreen extends StatelessWidget {
  final String email;

  const OtpPasswordResetScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OtpPasswordResetCubit(email: email, router: GoRouter.of(context)),
      child: Builder(
        builder: (context) {
          const gap24 = SizedBox(height: 24);
          const gap48 = SizedBox(height: 48);

          return CustomScaffold(
            body: NoPopWrapper(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: context.screenHeight * .9,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spacer(),
                        Text(
                          context
                              .l10n
                              .otpPasswordResetScreenTitle, // New localization key
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context
                              .l10n
                              .otpPasswordResetScreenSubtitle, // New localization key
                          style: context.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 0,
                          child: Column(
                            children: [
                              Text(context.l10n.emailVerificationCodeWasSent),
                              Text(
                                email,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              gap24,
                              OtpFields(
                                fieldCount: OtpPasswordResetCubit.codeLength,
                                onChanged: (index, value) {
                                  context
                                      .read<OtpPasswordResetCubit>()
                                      .onVerificationCodeDigitChanged(
                                        index,
                                        value,
                                      );
                                },
                              ),
                              gap24,
                              _ResendCodeSection(), // Will adapt this
                              const SizedBox(height: 60),
                              _SubmitButton(), // Will adapt this
                              gap48,
                              _ChangeEmailSection(), // Will adapt this
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Adapting components from EmailVerificationScreen
class _ResendCodeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpPasswordResetCubit, OtpPasswordResetState>(
      builder: (context, state) {
        return TextButton(
          onPressed: state.isBusy
              ? null
              : () => context.read<OtpPasswordResetCubit>().resendCode(),
          child: Text(
            context.l10n.resendVerificationCodeBtnLabel,
            style: TextStyle(
              color: state.isBusy
                  ? context.colorScheme.onSurface.withOpacity(0.38)
                  : context.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpPasswordResetCubit, OtpPasswordResetState>(
      listener: (context, state) {
        final pageLoader = PageLoader.of(context);
        if (state.isBusy) {
          pageLoader.show();
        } else {
          pageLoader.hide();
        }

        if (state is OtpPasswordResetSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.otpVerificationSuccess),
            ), // New localization key
          );
          // Navigation handled by cubit itself
        } else if (state is OtpPasswordResetFailureState) {
          showErrorDialog(
            context,
            title: context.l10n.error,
            errMessage:
                state.appError?.getMessage(context) ?? context.l10n.error,
          );
        }
      },
      builder: (context, state) {
        return FilledButton(
          onPressed: state.isBusy
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  context.read<OtpPasswordResetCubit>().onSubmit();
                },
          style: const ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
          ),
          child: Text(context.l10n.verifyBtnLabel),
        );
      },
    );
  }
}

class _ChangeEmailSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go(
          RoutePath.forgotPassword,
        ); // Navigate back to forgot password to change email
      },
      child: Text(
        context.l10n.changeEmail, // New localization key
        style: TextStyle(color: context.colorScheme.primary),
      ),
    );
  }
}
