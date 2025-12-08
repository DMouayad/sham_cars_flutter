part of 'signup_cubit.dart';

enum SignupStatus {
  success,
  pendingConfirmation,
  initial;

  static SignupStatus? byNameOrNull(String name) {
    try {
      return SignupStatus.values.byName(name);
    } catch (_) {
      return null;
    }
  }
}

class SignupState extends Equatable {
  const SignupState({
    required this.status,
    required this.role,
    required this.method,
    this.isBusy = false,
    this.appErr,
  });

  final SignupStatus status;

  final Role role;
  final SignupMethod method;
  final BaseAppError? appErr;
  final bool isBusy;

  bool get isSuccess => status == SignupStatus.success;
  bool get hasException => appErr != null;
  bool get isPendingConfirmation => status == SignupStatus.pendingConfirmation;

  @override
  List<Object?> get props => [status, appErr, role, method, isBusy];

  Map<String, dynamic> toJson() {
    final AppError? err = switch (appErr) {
      ApiError err => err.appErr,
      AppError() => appErr as AppError,
      _ => null,
    };
    return {
      "status": status.name,
      "appErr": err?.name,
      "role": role.name,
      "method": method.name,
      "isBusy": isBusy,
    };
  }

  // static SignupState? fromJson(Map<String, dynamic> json) {
  //   try {
  //     return SignupState(
  //       status: SignupStatus.byNameOrNull(json["status"]),
  //       appErr: AppError.byNameOrNull(json["appErr"]),
  //       role: Role.byNameOrNull(json["role"]),
  //       method: SignupMethod.byNameOrNull(json["method"]),
  //       isBusy: json["isBusy"],
  //     );
  //   } catch (e) {
  //     return null;
  //   }
  // }

  SignupState copyWith({
    SignupStatus? status,
    BaseAppError? appErr,
    Role? role,
    SignupMethod? method,
    bool? isBusy,
  }) {
    return SignupState(
      status: status ?? this.status,
      appErr: appErr,
      role: role ?? this.role,
      method: method ?? this.method,
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

  SignupState copyAsPendingConfirmation() {
    return copyWith(isBusy: false, status: SignupStatus.pendingConfirmation);
  }

  factory SignupState.initial(Role role, SignupMethod method) =>
      SignupState(status: SignupStatus.initial, role: role, method: method);
}
