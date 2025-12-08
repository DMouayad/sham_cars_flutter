part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState({required this.isBusy});
  final bool isBusy;
  @override
  List<Object?> get props => [isBusy];
}

final class LoginIdleState extends LoginState {
  const LoginIdleState() : super(isBusy: false);
}

final class LoginBusyState extends LoginState {
  const LoginBusyState() : super(isBusy: true);
}

final class LoginSuccessState extends LoginState {
  const LoginSuccessState() : super(isBusy: false);
}

final class LoginFailureState extends LoginState {
  final BaseAppError appError;
  const LoginFailureState(this.appError) : super(isBusy: false);
  @override
  List<Object?> get props => [appError, ...super.props];
}
