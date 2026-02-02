import 'package:equatable/equatable.dart';

import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';

import 'package:sham_cars/features/user/models/user.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  late final BlocHelpers _helpers;
  UserProfileCubit(User? user)
    : super(UserProfileState(user: user, isBusy: false)) {
    _helpers = BlocHelpers(
      emitProcessingRequest: () => emit(UserProfileBusyState(user: state.user)),
      setAsIdle: () => emit(const UserProfileState(isBusy: false)),
      onError: (err) =>
          emit(UserProfileFailureState(user: state.user, appErr: err)),
      isBusy: () => state.isBusy,
    );
  }

  IAuthRepository get _authRepository => GetIt.I.get();

  Future<void> onLogoutRequested() async {
    if (state.isBusy) {
      return;
    }
    _helpers.handleFuture(
      _authRepository.logOut(),
      onSuccess: (value) {
        GetIt.I.get<AuthNotifier>().updateCurrentUser(null);
      },
      onError: (err) => emit(LogoutFailureState(user: state.user, appErr: err)),
    );
  }

  void onDeleteAccountRequested() {}

  void onChangePasswordRequested() {}
}
