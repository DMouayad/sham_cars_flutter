import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sham_cars/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/error_dialog.dart';
import 'package:sham_cars/widgets/no_pop_wrapper.dart';
import 'package:sham_cars/widgets/otp_fields.dart';
import 'package:sham_cars/widgets/page_loader.dart';
part './components.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EmailVerificationCubit(email: email)),
      ],
      child: Builder(
        builder: (context) {
          const gap24 = SizedBox(height: 24);
          const gap48 = SizedBox(height: 48);

          return _Scaffold(
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
                          context.l10n.emailVerificationScreenTitle,
                          style: context.myTxtTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.emailVerificationScreenSubtitle,
                          style: context.myTxtTheme.bodyMedium,
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
                                fieldCount: 4,
                                onChanged: (index, value) {
                                  context
                                      .read<EmailVerificationCubit>()
                                      .onVerificationCodeDigitChanged(
                                        index,
                                        value,
                                      );
                                },
                              ),
                              gap24,
                              const _ResendCodeSection(),
                              const SizedBox(height: 60),
                              const _SubmitButton(),
                              gap48,

                              const _ChangeEmailSection(),
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
