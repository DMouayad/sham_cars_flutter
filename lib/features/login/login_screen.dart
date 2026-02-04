import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sham_cars/widgets/custom_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sham_cars/widgets/page_loader.dart';
import 'package:sham_cars/api/config.dart';
import 'package:sham_cars/features/login/cubit/login_cubit.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/form/email_text_field.dart';
import 'package:sham_cars/widgets/form/password_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({required this.redirectTo, super.key});
  final String redirectTo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          final pageLoader = PageLoader.of(context);
          if (state.isBusy) {
            pageLoader.show(message: context.l10n.loginInProgress);
          } else {
            pageLoader.hide();
          }
          switch (state) {
            case final LoginSuccessState state:
              final cubit = context.read<LoginCubit>();
              context.pushReplacement(
                state.redirectTo ?? redirectTo,
                extra: cubit.formHelper.emailValue,
              );
              break;
            case final LoginFailureState state:
              showErrorDialog(
                context,
                title: context.l10n.loginFailureDialogTitle,
                errMessage: state.appError.getMessage(context),
              );
              break;
            default:
              break;
          }
        },
        child: CustomScaffold(body: const LoginForm()),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formHelper = context.read<LoginCubit>().formHelper;
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
                    context.l10n.loginScreenSubtitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                EmailTextField(formHelper: formHelper),
                const Padding(padding: EdgeInsets.all(8)),
                PasswordTextField(
                  formHelper: formHelper,
                  textInputAction: TextInputAction.done,
                ),
                const ForgotPasswordButton(),
                const Padding(padding: EdgeInsets.all(12)),
                const _LoginButton(),
                const SizedBox(height: 48),
                const _CreateNewAccountSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateNewAccountSection extends StatelessWidget {
  const _CreateNewAccountSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.l10n.noAccountQuestion),
        const SizedBox(height: 16),
        Theme(
          data: context.theme.copyWith(
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  context.screenWidth < 400
                      ? context.myTxtTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : context.myTxtTheme.bodyMedium,
                ),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => const SignupRoute().pushReplacement(context),
                  child: Text(context.l10n.createAccountBtnLabel),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: const Key('loginForm_continue_raisedButton'),
      onPressed: () {
        FocusScope.of(context).unfocus();
        context.read<LoginCubit>().onLoginRequested();
      },
      style: const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
      ),
      child: Text(context.l10n.loginBtnLabel),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final Uri url = Uri.parse(
          ApiConfig.baseUrl + ApiConfig.forgotPasswordPageURL,
        );
        await launchUrl(url);
      },
      child: Text(context.l10n.forgotPasswordBtnLabel),
    );
  }
}
