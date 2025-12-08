part of 'user_profile_cubit.dart';

class UserProfileState extends Equatable {
  final bool isBusy;
  const UserProfileState({required this.isBusy});

  @override
  List<Object?> get props => [isBusy];
}

final class UserProfileIdleState extends UserProfileState {
  const UserProfileIdleState() : super(isBusy: false);
}

class UserProfileBusyState extends UserProfileState {
  const UserProfileBusyState() : super(isBusy: true);
}

class UserProfileFailureState extends UserProfileState {
  final BaseAppError appErr;
  const UserProfileFailureState(this.appErr) : super(isBusy: false);
  @override
  List<Object?> get props => [appErr, ...super.props];
}

class LogoutFailureState extends UserProfileFailureState {
  const LogoutFailureState(super.appErr);
}
