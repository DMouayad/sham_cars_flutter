import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';

part 'email_verification_state.dart';

const kVerificationCodeRequestInterval = Duration(minutes: 15);

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit({required this.email})
    : super(
        EmailVerificationUserInputState(
          digits: Map.fromIterable([0, 1, 2, 3], value: (_) => null),
          lastRequestedCodeAt: DateTime.now(),
        ),
      ) {
    _helpers = BlocHelpers(
      onError: (err) => emit(
        EmailVerificationFailureState(
          appException: err,
          digits: state.digits,
          lastRequestedCodeAt: state.lastRequestedCodeAt,
        ),
      ),
      emitProcessingRequest: () => emit(
        EmailVerificationInProgressState(
          digits: state.digits,
          lastRequestedCodeAt: state.lastRequestedCodeAt,
        ),
      ),
      setAsIdle: () => emit(
        EmailVerificationUserInputState(
          digits: state.digits,
          lastRequestedCodeAt: state.lastRequestedCodeAt,
        ),
      ),
      isBusy: () => state.isBusy,
    );
  }

  final String email;
  late final BlocHelpers _helpers;

  final IAuthRepository _authRepository = GetIt.I.get<IAuthRepository>();
  final AuthNotifier _authNotifier = GetIt.I.get<AuthNotifier>();

  void onVerificationCodeDigitChanged(int digit, String value) {
    if (digit > 3) {
      return;
    }
    final newDigits = Map<int, int?>.from(state.digits);
    newDigits[digit] = int.tryParse(value);
    emit(
      EmailVerificationUserInputState(
        digits: newDigits,
        lastRequestedCodeAt: state.lastRequestedCodeAt,
      ),
    );
  }

  void onSubmitCode() {
    if (state.inputIsValid()) {
      final code = state.digits.values.join();
      _helpers.handleFuture(
        _authRepository.verifyAccount((email: email, code: code)),
        onSuccess: (user) {
          _authNotifier.updateCurrentUser(user);
          emit(
            EmailVerificationSuccessState(
              lastRequestedCodeAt: state.lastRequestedCodeAt,
            ),
          );
        },
      );
    }
  }

  void onNewCodeRequested() {
    _helpers.handleFuture(
      _authRepository.resendVerificationCode(email),
      onSuccess: (_) => emit(
        EmailVerificationUserInputState(
          digits: state.digits,
          lastRequestedCodeAt: DateTime.now(),
        ),
      ),
    );
  }
}
