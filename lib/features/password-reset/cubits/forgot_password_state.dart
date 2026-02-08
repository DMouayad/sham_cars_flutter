part of 'forgot_password_cubit.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({required this.isBusy});
  final bool isBusy;
  @override
  List<Object?> get props => [isBusy];
}

final class ForgotPasswordIdleState extends ForgotPasswordState {
  const ForgotPasswordIdleState() : super(isBusy: false);
}

final class ForgotPasswordBusyState extends ForgotPasswordState {
  const ForgotPasswordBusyState() : super(isBusy: true);
}

final class ForgotPasswordSuccessState extends ForgotPasswordState {
  final String email;
  const ForgotPasswordSuccessState(this.email) : super(isBusy: false);
  @override
  List<Object?> get props => [email, ...super.props];
}

final class ForgotPasswordFailureState extends ForgotPasswordState {
  final BaseAppError appError;
  const ForgotPasswordFailureState(this.appError) : super(isBusy: false);
  @override
  List<Object?> get props => [appError, ...super.props];
}
