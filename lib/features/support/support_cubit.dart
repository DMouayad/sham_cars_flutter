import 'package:flutter_bloc/flutter_bloc.dart';

import 'models.dart';
import 'support_repository.dart';

class SupportState {
  const SupportState({this.loading = false, this.data, this.error});
  final bool loading;
  final AppSupport? data;
  final String? error;

  SupportState copyWith({bool? loading, AppSupport? data, String? error}) {
    return SupportState(
      loading: loading ?? this.loading,
      data: data ?? this.data,
      error: error,
    );
  }
}

class SupportCubit extends Cubit<SupportState> {
  SupportCubit(this._repo) : super(const SupportState());
  final SupportRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await _repo.getSupportInfo();
      emit(state.copyWith(loading: false, data: data));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> refresh() => load();
}
