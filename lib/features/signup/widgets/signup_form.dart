import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/features/user/models.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/form/email_text_field.dart';
import 'package:sham_cars/widgets/form/phone_text_field.dart';

import 'base_signup_form.dart';
import 'have_existing_account_section.dart';
import 'signup_button.dart';
import 'switch_method_button.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSignupForm(
      builder: (formHelper, formGap) => [
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (prev, current) => prev.method != current.method,
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
              key: ValueKey(state.method),
              children: [
                SizedBox(
                  height: 56,
                  child: Text(
                    state.method.isEmail
                        ? context.l10n.signupWithEmailMessage
                        : context.l10n.signupWithPhoneMessage,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                formGap,
                state.method.isEmail
                    ? EmailTextField(formHelper: formHelper)
                    : PhoneTextField(
                        controller: formHelper.phoneNoController,
                        validator: formHelper.phoneNoValidator,
                      ),
              ],
            ),
          ),
        ),
        formGap,
        const SignupButton(),
        const SizedBox(height: 44),
        const SwitchSignupMethodButton(),
        formGap,
        const HaveExistingAccountSection(),
      ],
    );
  }
}

String getSignupSubtitle(BuildContext context) {
  final state = context.read<SignupCubit>().state;

  return switch (state.role) {
    Role.patient => context.l10n.signupAsPatientScreenTitle,
    Role.physician => context.l10n.signupAsDoctorScreenTitle,
    Role.guest => throw UnimplementedError(),
  };
}
