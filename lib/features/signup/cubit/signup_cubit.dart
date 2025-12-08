import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/api/requests/auth_requests.dart';

import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/signup/models/signup_form_helper.dart';
import 'package:sham_cars/features/signup/models/signup_method.dart';
import 'package:sham_cars/features/user/models.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  late final SignupFormHelper formHelper;
  late final BlocHelpers _helpers;
  late final ValueNotifier<Duration> durationToRequestNewCode;

  Timer? _requestingNewCodeTimer;

  IAuthRepository get _authRepo => GetIt.I.get();

  SignupCubit({required Role signupAs, required SignupMethod method})
    : super(SignupState.initial(signupAs, method)) {
    formHelper = SignupFormHelper();
    _helpers = BlocHelpers(
      onError: (err) {
        if (err case ApiError apiError
            when apiError.appErr == AppError.rateLimitExceeded) {
          if (apiError.extra case http.Response res) {
            if (int.tryParse(res.headers['retry-after'] ?? '')
                case int retryAfterSec) {
              _startTimer(Duration(seconds: retryAfterSec));
            }
          }
        }

        emit(state.copyWithError(err));
      },
      emitProcessingRequest: () =>
          emit(state.copyWith(isBusy: true, appErr: null)),
      setAsIdle: () => emit(state.copyWithBusy(false)),
      isBusy: () => state.isBusy,
    );
    durationToRequestNewCode = ValueNotifier(Duration.zero);
  }
  void _startTimer(Duration duration) {
    _requestingNewCodeTimer?.cancel();
    _requestingNewCodeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _timerCallback(timer, duration.inSeconds),
    );
  }

  void _timerCallback(Timer timer, int durationInSec) {
    durationToRequestNewCode.value = Duration(
      seconds: durationInSec - timer.tick,
    );
    if (durationToRequestNewCode.value.inSeconds <= 0) {
      timer.cancel();
    }
  }

  Future<void> onStartSignup() async {
    if (!formHelper.validateInput(validateSignupCode: false) || state.isBusy) {
      return;
    }
    switch (state.method) {
      case SignupMethod.email:
        await _onStartSignupWithEmail();
        break;
      case SignupMethod.phone:
        await _onStartSignupWithPhone();
        break;
    }
  }

  Future<void> _onStartSignupWithEmail() async {
    final StartSignupWithEmailRequest req = (
      role: state.role,
      email: formHelper.emailValue,
    );

    _helpers.handleFuture(
      _authRepo.signupWithEmail(req),
      onSuccess: (_) {
        _startTimer(const Duration(seconds: 30));

        emit(state.copyAsPendingConfirmation());
      },
    );
  }

  Future<void> _onStartSignupWithPhone() async {
    final StartSignupWithPhoneRequest req = (
      role: state.role,
      phoneNumber: formHelper.phoneNoValue,
    );

    _helpers.handleFuture(
      _authRepo.signupWithPhone(req),
      onSuccess: (_) {
        _startTimer(const Duration(seconds: 30));
        emit(state.copyAsPendingConfirmation());
      },
    );
  }

  Future<void> onConfirmSignup() async {
    if (!formHelper.validateInput(validateSignupCode: true) || state.isBusy) {
      return;
    }
    switch (state.method) {
      case SignupMethod.email:
        await _onConfirmSignupWithEmail();
        break;
      case SignupMethod.phone:
        await _onConfirmSignupWithPhone();
        break;
    }
  }

  Future<void> _onConfirmSignupWithEmail() async {
    final ConfirmSignupWithEmailRequest req = (
      signupCode: formHelper.signupCodeValue,
      role: state.role,
      email: formHelper.emailValue,
      password: formHelper.passwordValue,
    );
    _helpers.handleFuture(
      _authRepo.confirmSignupWithEmail(req),
      onSuccess: (value) {
        Timer(const Duration(seconds: 2), () => emit(state.copyAsSuccess()));
      },
    );
  }

  Future<void> _onConfirmSignupWithPhone() async {
    final ConfirmSignupWithPhoneRequest req = (
      signupCode: formHelper.signupCodeValue,
      role: state.role,
      phoneNumber: formHelper.phoneNoValue,
      password: formHelper.passwordValue,
    );
    _helpers.handleFuture(
      _authRepo.confirmSignupWithPhone(req),
      onSuccess: (value) => {emit(state.copyAsSuccess())},
    );
  }

  void switchSignupMethod(SignupMethod method) {
    emit(state.copyWith(method: method));
  }

  void onNewCodeRequested() {
    if (formHelper.phoneNoValue.isNotEmpty) {
      _onStartSignupWithPhone();
    } else if (formHelper.emailValue.isNotEmpty) {
      _onStartSignupWithEmail();
    }
  }
}
