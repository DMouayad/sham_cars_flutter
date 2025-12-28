part of 'signup_cubit.dart';

enum SignupStatus {
  success,
  pendingVerification,
  initial;

  static SignupStatus? byNameOrNull(String name) {
    try {
      return SignupStatus.values.byName(name);
    } catch (_) {
      return null;
    }
  }
}

class SignupState extends Equatable implements BaseState<SignupState> {
  const SignupState({required this.status, this.isBusy = false, this.appErr});

  final SignupStatus status;
  @override
  final BaseAppError? appErr;
  @override
  final bool isBusy;

  bool get isSuccess => status == SignupStatus.success;
  bool get hasException => appErr != null;
  bool get isPendingVerification => status == SignupStatus.pendingVerification;

  @override
  List<Object?> get props => [status, appErr, isBusy];

  Map<String, dynamic> toJson() {
    final AppError? err = switch (appErr) {
      ApiError err => err.appErr,
      AppError() => appErr as AppError,
      _ => null,
    };
    return {"status": status.name, "appErr": err?.name, "isBusy": isBusy};
  }

  static SignupState? fromJson(Map<String, dynamic> json) {
    try {
      return SignupState(
        status:
            SignupStatus.byNameOrNull(json["status"]) ?? SignupStatus.initial,
        appErr: AppError.byNameOrNull(json["appErr"]),
        isBusy: json["isBusy"],
      );
    } catch (e) {
      return null;
    }
  }

  SignupState copyWith({
    SignupStatus? status,
    BaseAppError? appErr,
    Role? role,
    bool? isBusy,
  }) {
    return SignupState(
      status: status ?? this.status,
      appErr: appErr,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  SignupState copyWithBusy(bool isBusy) {
    return copyWith(isBusy: isBusy);
  }

  SignupState copyWithError(BaseAppError? err) {
    return copyWith(appErr: err, isBusy: false);
  }

  SignupState copyAsSuccess() {
    return copyWith(status: SignupStatus.success);
  }

  SignupState copyAsPendingVerification() {
    return copyWith(isBusy: false, status: SignupStatus.pendingVerification);
  }

  factory SignupState.initial() => SignupState(status: SignupStatus.initial);
}
