import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/user/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../models/auth_state.dart';

class AuthStateCubit extends HydratedCubit<AuthState> {
  IAuthRepository get _authRepository => GetIt.I.get();

  AuthStateCubit() : super(AuthState.unauthenticated()) {
    _authRepository.state.listen(_onAuthRepoStateChange);
  }

  void _onAuthRepoStateChange(AuthState state) => emit(state);

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    if (User.fromJsonObj(json) case User user) {
      return AuthState.authenticated(user);
    }
    return AuthState.unauthenticated();
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.user?.toJson() ?? {};
  }
}
