import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/api/config.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/features/signup/widgets/base_signup_form.dart';
import 'package:sham_cars/features/signup/widgets/signup_button.dart';
import 'package:sham_cars/features/signup/widgets/signup_form_fields.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/form/password_text_field.dart';
import 'package:sham_cars/widgets/otp_fields.dart';

class SignupConfirmationScreen extends StatelessWidget {
  const SignupConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<SignupCubit>().state;

    return BaseSignupForm(
      builder: (formHelper, gap) => [
        Wrap(
          spacing: 0,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            Text(
              state.method.isEmail
                  ? context.l10n.signupCodeSentToEmail
                  : context.l10n.signupCodeSentToPhone,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              state.method.isEmail
                  ? formHelper.emailValue
                  : formHelper.phoneNoValue,
              textDirection: TextDirection.ltr,
              style: context.textTheme.titleMedium,
            ),
          ],
        ),
        gap,
        OtpFields(
          digitFieldDimension: 50,
          fieldCount: ApiConfig.signupCodeLength,
          onChanged: formHelper.updateSignupCodeDigit,
        ),
        ValueListenableBuilder(
          valueListenable: formHelper.showSignupCodeValidationErrorMsg,
          builder: (context, value, child) {
            return Visibility(visible: value, child: child!);
          },
          child: Text(
            context.l10n.signupCodeIsRequired,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.error,
            ),
          ),
        ),
        gap,
        const RequestNewCodeSection(),
        gap,
        ValueListenableBuilder(
          valueListenable: formHelper.signupCodeIsComplete,
          builder: (context, value, child) {
            return Visibility(visible: value, child: child!);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.createPasswordMessage,
                style: context.textTheme.titleMedium,
              ),
              gap,
              PasswordTextField(
                formHelper: formHelper,
                isForCreatingPassword: true,
              ),
              gap,
              PasswordConfirmationTextField(formHelper: formHelper),
            ],
          ),
        ),
        const SizedBox(height: 48),
        const SignupButton(),
      ],
    );
  }
}

class RequestNewCodeSection extends StatelessWidget {
  const RequestNewCodeSection({super.key});
  String formatDuration(Duration duration, BuildContext context) {
    final seconds = duration.inSeconds;
    if (seconds < 60) {
      return '${seconds.toString().padLeft(2, '0')} ${context.l10n.sec}';
    }
    return duration.toString().split('.').first;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(context.l10n.didNotReceiveCode),
        ValueListenableBuilder(
          valueListenable: context.read<SignupCubit>().durationToRequestNewCode,
          builder: (context, value, child) {
            return AnimatedCrossFade(
              crossFadeState: value == Duration.zero
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Wrap(
                children: [
                  Text(
                    context.l10n.resendVerificationCodeIn,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(' ${formatDuration(value, context)}'),
                ],
              ),
              secondChild: TextButton(
                onPressed: context.read<SignupCubit>().onNewCodeRequested,
                child: Text(context.l10n.resendVerificationCodeBtnLabel),
              ),
              duration: const Duration(milliseconds: 300),
            );
          },
        ),
      ],
    );
  }
}
