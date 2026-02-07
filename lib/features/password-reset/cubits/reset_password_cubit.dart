import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/password-reset/password_reset_form_helper.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final PasswordResetFormHelper formHelper;
  final String? token;
  late final BlocHelpers _helpers;

  ResetPasswordCubit({this.token})
    : formHelper = PasswordResetFormHelper(),
      super(const ResetPasswordIdleState()) {
    _helpers = BlocHelpers(
      onError: (err) => emit(ResetPasswordFailureState(err)),
      emitProcessingRequest: () => emit(const ResetPasswordBusyState()),
      setAsIdle: () => emit(const ResetPasswordIdleState()),
      isBusy: () => state.isBusy,
    );
  }

  Future<void> onSubmit() async {
    if (!formHelper.validateInput() || state.isBusy) {
      return;
    }
    if (formHelper.passwordValue != formHelper.confirmPasswordValue) {
      emit(const ResetPasswordFailureState(AppError.passwordMismatch));
      return;
    }
    if (token == null) {
      emit(const ResetPasswordFailureState(AppError.invalidToken));
      return;
    }
    _helpers.handleFuture(
      GetIt.I.get<IAuthRepository>().resetPassword(
        token!,
        formHelper.passwordValue,
        formHelper.confirmPasswordValue,
      ),
      onSuccess: (_) {
        GetIt.I.get<AuthNotifier>().endPasswordResetSession();
        emit(const ResetPasswordSuccessState());
      },
    );
  }
}
