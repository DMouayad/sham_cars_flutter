import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sham_cars/features/signup/widgets/signup_form_fields.dart';
import 'package:sham_cars/widgets/custom_scaffold.dart';
import 'package:sham_cars/widgets/page_loader.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/form/password_text_field.dart';
import 'package:sham_cars/features/password-reset/cubits/reset_password_cubit.dart';
import 'package:sham_cars/router/routes.dart';

class ResetPasswordScreen extends StatelessWidget {
  /// The token usually obtained from the deep link query params
  final String? resetToken;

  const ResetPasswordScreen({super.key, this.resetToken});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(token: resetToken),
      child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          final pageLoader = PageLoader.of(context);
          if (state.isBusy) {
            pageLoader.show();
          } else {
            pageLoader.hide();
          }

          if (state is ResetPasswordSuccessState) {
            // Navigate to login or home
            context.go(RoutePath.login);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.passwordResetSuccess)),
            );
          } else if (state is ResetPasswordFailureState) {
            showErrorDialog(
              context,
              title: context.l10n.error,
              errMessage: state.appError.getMessage(context),
            );
          }
        },
        child: const CustomScaffold(body: _ResetPasswordForm()),
      ),
    );
  }
}

class _ResetPasswordForm extends StatelessWidget {
  const _ResetPasswordForm();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetPasswordCubit>();
    final formHelper = cubit.formHelper;

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
                    context.l10n.resetPasswordTitle,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // New Password
                // Note: Ensure your PasswordTextField allows changing the label
                // via arguments or defaults to "Password"
                PasswordTextField(
                  formHelper: formHelper,
                  textInputAction: TextInputAction.next,
                  isForCreatingPassword: true,

                  // If your widget supports custom labels:
                  // label: context.l10n.newPasswordLabel,
                ),

                const SizedBox(height: 16),

                // Confirm Password
                PasswordConfirmationTextField(formHelper: formHelper),

                const SizedBox(height: 32),

                FilledButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context.read<ResetPasswordCubit>().onSubmit();
                  },
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
                  ),
                  child: Text(context.l10n.resetPasswordBtnLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
