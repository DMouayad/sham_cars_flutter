part of 'email_verification_cubit.dart';

sealed class EmailVerificationState extends Equatable {
  const EmailVerificationState({
    required this.digits,
    required this.lastRequestedCodeAt,
    this.isBusy = false,
  });

  final DateTime lastRequestedCodeAt;

  final Map<int, int?> digits;

  final bool isBusy;

  bool inputIsValid() {
    return digits.length == 4 && digits.values.every((d) => d != null);
  }

  bool canRequestNewCode() {
    return DateTime.now().isAfter(
      lastRequestedCodeAt.add(kVerificationCodeRequestInterval),
    );
  }

  @override
  String toString() {
    return '$runtimeType(isBusy:$isBusy, lastRequestCodeAt:$lastRequestedCodeAt, digits:${digits.values.join("-")})';
  }

  @override
  List<Object?> get props => [isBusy, digits, lastRequestedCodeAt];
}

final class EmailVerificationUserInputState extends EmailVerificationState {
  const EmailVerificationUserInputState({
    required super.digits,
    required super.lastRequestedCodeAt,
  }) : super(isBusy: false);
}

final class EmailVerificationInProgressState extends EmailVerificationState {
  const EmailVerificationInProgressState({
    required super.digits,
    required super.lastRequestedCodeAt,
  }) : super(isBusy: true);
}

final class EmailVerificationSuccessState extends EmailVerificationState {
  const EmailVerificationSuccessState({required super.lastRequestedCodeAt})
    : super(isBusy: false, digits: const {});
}

final class EmailVerificationFailureState extends EmailVerificationState {
  const EmailVerificationFailureState({
    required this.appException,
    required super.digits,
    required super.lastRequestedCodeAt,
  }) : super(isBusy: false);

  final BaseAppError appException;

  @override
  List<Object?> get props => [appException, ...super.props];
}
