import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';

part 'otp_password_reset_state.dart';

class OtpPasswordResetCubit extends Cubit<OtpPasswordResetState> {
  final String email;
  final GoRouter _router;
  late final BlocHelpers _helpers;

  OtpPasswordResetCubit({required this.email, required GoRouter router})
    : _router = router,
      super(const OtpPasswordResetIdleState()) {
    _helpers = BlocHelpers(
      onError: (err) => emit(OtpPasswordResetFailureState(err)),
      emitProcessingRequest: () => emit(const OtpPasswordResetBusyState()),
      setAsIdle: () => emit(const OtpPasswordResetIdleState()),
      isBusy: () => state.isBusy,
    );
  }
  static const int codeLength = 4;

  final List<String> _digits = List.filled(codeLength, '');

  void onVerificationCodeDigitChanged(int index, String digit) {
    if (index < 0 || index >= codeLength) return;
    _digits[index] = digit.isEmpty ? '' : digit.characters.last;
  }

  String get code => _digits.join();
  bool get isComplete => _digits.every((d) => d.isNotEmpty);

  Future<void> onSubmit() async {
    if (!isComplete || state.isBusy) {
      emit(const OtpPasswordResetFailureState(AppError.invalidOtp));
      return;
    }

    _helpers.handleFuture(
      GetIt.I.get<IAuthRepository>().verifyOtpForPasswordReset(email, code),
      onSuccess: (_) {
        GetIt.I.get<AuthNotifier>().endPasswordResetSession();
        emit(const OtpPasswordResetSuccessState());
        _router.go(RoutePath.resetPassword);
      },
    );
  }

  Future<void> resendCode() async {
    _helpers.handleFuture(
      GetIt.I.get<IAuthRepository>().forgotPassword(email),
      onSuccess: (_) {
        // Optionally show a message that the code has been re-sent
        emit(
          const OtpPasswordResetIdleState(message: 'OTP re-sent successfully'),
        );
      },
    );
  }
}
