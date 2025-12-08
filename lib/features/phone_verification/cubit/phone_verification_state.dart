part of 'phone_verification_cubit.dart';

sealed class PhoneVerificationState extends Equatable {
  const PhoneVerificationState({
    required this.digits,
    required this.isBusy,
    required this.lastRequestedCodeAt,
  });

  final DateTime lastRequestedCodeAt;

  final Map<int, int?> digits;

  final bool isBusy;

  bool inputIsValid() {
    return digits.length == 4 && digits.values.every((d) => d != null);
  }

  bool canRequestNewCode() {
    return DateTime.now()
        .isAfter(lastRequestedCodeAt.add(kVerificationCodeRequestInterval));
  }

  @override
  String toString() {
    return '$runtimeType(isBusy:$isBusy, lastRequestCodeAt:$lastRequestedCodeAt, digits:${digits.values.join("-")})';
  }

  @override
  List<Object?> get props => [isBusy, digits, lastRequestedCodeAt];
}

final class PhoneVerificationUserInputState extends PhoneVerificationState {
  const PhoneVerificationUserInputState(
      {required super.digits, required super.lastRequestedCodeAt})
      : super(isBusy: false);
}

final class PhoneVerificationInProgressState extends PhoneVerificationState {
  const PhoneVerificationInProgressState(
      {required super.digits, required super.lastRequestedCodeAt})
      : super(isBusy: true);
}

final class PhoneVerificationSuccessState extends PhoneVerificationState {
  const PhoneVerificationSuccessState({required super.lastRequestedCodeAt})
      : super(isBusy: true, digits: const {});
}

final class PhoneVerificationFailureState extends PhoneVerificationState {
  const PhoneVerificationFailureState({
    required this.appException,
    required super.digits,
    required super.lastRequestedCodeAt,
  }) : super(isBusy: true);

  final BaseAppError appException;

  @override
  List<Object?> get props => [appException, ...super.props];
}
