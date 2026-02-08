import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';
import 'package:sham_cars/features/password-reset/utils/forgot_password_form_helper.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordFormHelper formHelper;

  late final BlocHelpers _helpers;

  ForgotPasswordCubit()
    : formHelper = ForgotPasswordFormHelper(),
      super(const ForgotPasswordIdleState()) {
    _helpers = BlocHelpers(
      onError: (err) => emit(ForgotPasswordFailureState(err)),
      emitProcessingRequest: () => emit(const ForgotPasswordBusyState()),
      setAsIdle: () => emit(const ForgotPasswordIdleState()),
      isBusy: () => state.isBusy,
    );
  }

  Future<void> onSubmit() async {
    if (!formHelper.validateInput() || state.isBusy) {
      return;
    }
    _helpers.handleFuture(
      GetIt.I.get<IAuthRepository>().forgotPassword(formHelper.emailValue),
      onSuccess: (_) {
        emit(ForgotPasswordSuccessState(formHelper.emailValue));
      },
    );
  }
}
