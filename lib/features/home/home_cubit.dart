import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/common/data_state.dart';

import 'home_repository.dart';
import 'models.dart';

class HomeCubit extends Cubit<DataState<HomeData>> {
  final HomeRepository _repo;

  HomeCubit(this._repo) : super(const DataInitial());

  Future<void> load() async {
    emit(const DataLoading());
    try {
      final data = await _repo.getHomeData();
      emit(DataLoaded(data));
    } catch (e) {
      emit(DataError(e));
    }
  }

  Future<void> refresh() => load();
}
