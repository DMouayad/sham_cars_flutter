part of 'reset_password_cubit.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState({required this.isBusy});
  final bool isBusy;
  @override
  List<Object?> get props => [isBusy];
}

final class ResetPasswordIdleState extends ResetPasswordState {
  const ResetPasswordIdleState() : super(isBusy: false);
}

final class ResetPasswordBusyState extends ResetPasswordState {
  const ResetPasswordBusyState() : super(isBusy: true);
}

final class ResetPasswordSuccessState extends ResetPasswordState {
  const ResetPasswordSuccessState() : super(isBusy: false);
}

final class ResetPasswordFailureState extends ResetPasswordState {
  final BaseAppError appError;
  const ResetPasswordFailureState(this.appError) : super(isBusy: false);
  @override
  List<Object?> get props => [appError, ...super.props];
}