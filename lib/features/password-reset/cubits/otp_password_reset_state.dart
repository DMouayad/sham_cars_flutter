part of 'otp_password_reset_cubit.dart';

sealed class OtpPasswordResetState extends Equatable {
  final bool isBusy;
  final String? message;
  final BaseAppError? appError;

  const OtpPasswordResetState({
    this.isBusy = false,
    this.message,
    this.appError,
  });

  @override
  List<Object?> get props => [isBusy, message, appError];
}

class OtpPasswordResetIdleState extends OtpPasswordResetState {
  const OtpPasswordResetIdleState({super.message});
}

class OtpPasswordResetBusyState extends OtpPasswordResetState {
  const OtpPasswordResetBusyState() : super(isBusy: true);
}

class OtpPasswordResetSuccessState extends OtpPasswordResetState {
  const OtpPasswordResetSuccessState();
}

class OtpPasswordResetFailureState extends OtpPasswordResetState {
  const OtpPasswordResetFailureState(BaseAppError appError)
    : super(appError: appError);
}
