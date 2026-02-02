import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/login/login_form_helper.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginFormHelper formHelper;
  late final BlocHelpers _helpers;

  LoginCubit() : formHelper = LoginFormHelper(), super(const LoginIdleState()) {
    _helpers = BlocHelpers(
      onError: (err) => emit(LoginFailureState(err)),
      emitProcessingRequest: () => emit(const LoginBusyState()),
      setAsIdle: () => emit(const LoginIdleState()),
      isBusy: () => state.isBusy,
    );
  }

  Future<void> onLoginRequested() async {
    if (!formHelper.validateInput() || state.isBusy) {
      return;
    }
    _helpers.handleFuture(
      GetIt.I.get<IAuthRepository>().logIn((
        emailOrPhone: formHelper.emailValue,
        password: formHelper.passwordValue,
      )),
      onError: (exception) {
        if (exception == AppError.unauthenticated) {
          emit(const LoginFailureState(AppError.invalidLoginCredential));
        } else if (exception case ApiError apiErr
            when apiErr.statusCode == 403) {
          emit(
            const LoginSuccessState(redirectTo: RoutePath.emailVerification),
          );
        } else {
          _helpers.onError(exception);
        }
      },
      onSuccess: (user) {
        GetIt.I.get<AuthNotifier>().updateCurrentUser(user);
        emit(const LoginSuccessState());
      },
    );
  }
}
