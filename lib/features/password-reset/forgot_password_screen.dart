import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sham_cars/widgets/custom_scaffold.dart';
import 'package:sham_cars/widgets/page_loader.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/form/email_text_field.dart';

import 'cubits/forgot_password_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          final pageLoader = PageLoader.of(context);
          if (state.isBusy) {
            pageLoader.show();
          } else {
            pageLoader.hide();
          }

          if (state is ForgotPasswordSuccessState) {
            // Show success and maybe navigate to verify code or login
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.resetLinkSentMessage)),
            );
            context.pop(); // Go back to login
          } else if (state is ForgotPasswordFailureState) {
            showErrorDialog(
              context,
              title: context.l10n.error,
              errMessage: state.appError.getMessage(context),
            );
          }
        },
        child: const CustomScaffold(body: _ForgotPasswordForm()),
      ),
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm();

  @override
  Widget build(BuildContext context) {
    final formHelper = context.read<ForgotPasswordCubit>().formHelper;

    return Form(
      key: formHelper.formKey,
      child: Center(
        child: Container(
          constraints: BoxConstraints.tight(
            Size.fromWidth(min(420, context.screenWidth * .9)),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    context.l10n.forgotPasswordBtnLabel,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    context
                        .l10n
                        .forgotPasswordSubtitle, // "Enter your email..."
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                EmailTextField(formHelper: formHelper),

                const SizedBox(height: 32),

                FilledButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context.read<ForgotPasswordCubit>().onSubmit();
                  },
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
                  ),
                  child: Text(context.l10n.sendResetLinkBtnLabel),
                ),

                const SizedBox(height: 24),

                // Back to Login Link
                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: Text(context.l10n.backToLogin),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
