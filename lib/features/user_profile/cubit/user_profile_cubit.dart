import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  late final BlocHelpers _helpers;
  UserProfileCubit() : super(const UserProfileIdleState()) {
    _helpers = BlocHelpers(
      emitProcessingRequest: () => emit(const UserProfileBusyState()),
      setAsIdle: () => emit(const UserProfileIdleState()),
      onError: (err) => emit(UserProfileFailureState(err)),
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
      onSuccess: (value) {},
      onError: (err) => emit(LogoutFailureState(err)),
    );
  }

  void onDeleteAccountRequested() {}

  void onChangePasswordRequested() {}
}
