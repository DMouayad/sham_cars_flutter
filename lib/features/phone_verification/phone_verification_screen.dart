import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:sham_cars/features/phone_verification/cubit/phone_verification_cubit.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/no_pop_wrapper.dart';
import 'package:sham_cars/widgets/otp_fields.dart';
import 'package:sham_cars/widgets/page_loader.dart';
part './components.dart';

class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({super.key, required this.signupCubit});
  final SignupCubit signupCubit;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PhoneVerificationCubit()),
        BlocProvider.value(value: signupCubit),
      ],
      child: Builder(builder: (context) => const _PhoneVerificationView()),
    );
  }
}

class _PhoneVerificationView extends StatelessWidget {
  const _PhoneVerificationView();

  @override
  Widget build(BuildContext context) {
    const gap24 = SizedBox(height: 24);
    const gap48 = SizedBox(height: 48);

    String getPhoneNumber(BuildContext context) {
      return switch (context.read<SignupCubit>().state) {
        // SignupPendingPhoneVerificationState s => s.dto.phoneNumber,
        _ => '',
      };
    }

    return _PhoneVerificationScaffold(
      child: NoPopWrapper(
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
                    context.l10n.phoneVerificationScreenTitle,
                    style: context.myTxtTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.phoneVerificationScreenSubtitle,
                    style: context.myTxtTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 0,
                    child: Column(
                      children: [
                        Text(context.l10n.phoneVerificationCodeWasSent),
                        Text(
                          getPhoneNumber(context),
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        gap24,
                        OtpFields(
                          fieldCount: 4,
                          onChanged: (index, value) {
                            context
                                .read<PhoneVerificationCubit>()
                                .onVerificationCodeDigitChanged(index, value);
                          },
                        ),
                        gap24,
                        const _ResendCodeSection(),
                        const SizedBox(height: 60),
                        const _SubmitButton(),
                        gap48,

                        const _ChangeNumberSection(),
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
  }
}
