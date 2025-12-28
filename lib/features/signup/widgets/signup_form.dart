import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/form/email_text_field.dart';
import 'package:sham_cars/widgets/form/password_text_field.dart';
import 'package:sham_cars/widgets/form/phone_text_field.dart';

import 'base_signup_form.dart';
import 'have_existing_account_section.dart';
import 'signup_button.dart';
import 'signup_form_fields.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSignupForm(
      builder: (formHelper, formGap) => [
        BlocBuilder<SignupCubit, SignupState>(
          builder: (context, state) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Column(
              spacing: formGap.padding.vertical,
              children: [
                Text(
                  context.l10n.signupScreenTitle,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.secondary,
                  ),
                ),
                formGap,
                EmailTextField(formHelper: formHelper),
                PhoneTextField(
                  controller: formHelper.phoneNoController,
                  validator: formHelper.phoneNoValidator,
                ),
                PasswordTextField(
                  formHelper: formHelper,
                  isForCreatingPassword: true,
                ),
                PasswordConfirmationTextField(formHelper: formHelper),
              ],
            ),
          ),
        ),
        formGap,
        const SignupButton(),
        const SizedBox(height: 44),
        formGap,
        const HaveExistingAccountSection(),
      ],
    );
  }
}
