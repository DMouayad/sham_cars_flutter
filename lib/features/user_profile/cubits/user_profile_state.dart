part of 'user_profile_cubit.dart';

class UserProfileState extends Equatable {
  final bool isBusy;
  final User? user;
  const UserProfileState({required this.isBusy, this.user});

  @override
  List<Object?> get props => [isBusy];
}

class UserProfileBusyState extends UserProfileState {
  const UserProfileBusyState({required super.user}) : super(isBusy: true);
}

class UserProfileFailureState extends UserProfileState {
  final BaseAppError appErr;
  const UserProfileFailureState({required super.user, required this.appErr})
    : super(isBusy: false);
  @override
  List<Object?> get props => [appErr, ...super.props];
}

class LogoutFailureState extends UserProfileFailureState {
  const LogoutFailureState({required super.user, required super.appErr});
}
