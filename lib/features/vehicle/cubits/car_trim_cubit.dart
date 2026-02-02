import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/common/data_state.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import '../repositories/car_data_repository.dart';

class CarTrimCubit extends Cubit<DataState<CarTrim>> {
  final CarDataRepository _repo;

  CarTrimCubit(this._repo) : super(const DataInitial());

  Future<void> load(int id) async {
    emit(const DataLoading());
    try {
      final data = await _repo.getTrim(id);
      emit(DataLoaded(data));
    } catch (e) {
      emit(DataError(e));
    }
  }
}
