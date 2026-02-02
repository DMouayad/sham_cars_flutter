import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import '../repositories/car_data_repository.dart';

class VehiclesListState {
  final List<CarModel> models;
  final List<BodyType> bodyTypes;
  final List<CarMake> makes;
  final int? selectedBodyTypeId;
  final int? selectedMakeId;
  final bool isLoading;
  final bool isFiltersLoading;
  final Object? error;
  final String searchQuery;

  const VehiclesListState({
    this.models = const [],
    this.bodyTypes = const [],
    this.makes = const [],
    this.selectedBodyTypeId,
    this.selectedMakeId,
    this.isLoading = false,
    this.isFiltersLoading = false,
    this.error,
    this.searchQuery = '',
  });

  VehiclesListState copyWith({
    List<CarModel>? models,
    List<BodyType>? bodyTypes,
    List<CarMake>? makes,
    int? selectedBodyTypeId,
    int? selectedMakeId,
    bool? isLoading,
    bool? isFiltersLoading,
    Object? error,
    String? searchQuery,
    bool clearBodyType = false,
    bool clearMake = false,
  }) {
    return VehiclesListState(
      models: models ?? this.models,
      bodyTypes: bodyTypes ?? this.bodyTypes,
      makes: makes ?? this.makes,
      selectedBodyTypeId: clearBodyType
          ? null
          : (selectedBodyTypeId ?? this.selectedBodyTypeId),
      selectedMakeId: clearMake
          ? null
          : (selectedMakeId ?? this.selectedMakeId),
      isLoading: isLoading ?? this.isLoading,
      isFiltersLoading: isFiltersLoading ?? this.isFiltersLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasFilters => selectedBodyTypeId != null || selectedMakeId != null;

  List<CarModel> get filteredModels {
    if (searchQuery.isEmpty) return models;
    final q = searchQuery.toLowerCase();
    return models.where((m) {
      return m.name.toLowerCase().contains(q) ||
          m.makeName.toLowerCase().contains(q);
    }).toList();
  }

  BodyType? get selectedBodyType =>
      bodyTypes.where((b) => b.id == selectedBodyTypeId).firstOrNull;

  CarMake? get selectedMake =>
      makes.where((m) => m.id == selectedMakeId).firstOrNull;
}

class VehiclesListCubit extends Cubit<VehiclesListState> {
  final CarDataRepository _repo;

  VehiclesListCubit(this._repo) : super(const VehiclesListState());

  Future<void> init() async {
    emit(state.copyWith(isFiltersLoading: true, isLoading: true));

    try {
      await RestClient.runCached(() async {
        final results = await Future.wait([
          _repo.getBodyTypes(),
          _repo.getMakes(),
          _repo.getModels(),
        ]);

        emit(
          state.copyWith(
            bodyTypes: results[0] as List<BodyType>,
            makes: results[1] as List<CarMake>,
            models: results[2] as List<CarModel>,
            isFiltersLoading: false,
            isLoading: false,
          ),
        );
      });
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false, isFiltersLoading: false));
    }
  }

  Future<void> applyFilters({int? bodyTypeId, int? makeId}) async {
    emit(
      state.copyWith(
        selectedBodyTypeId: bodyTypeId,
        selectedMakeId: makeId,
        clearBodyType: bodyTypeId == null,
        clearMake: makeId == null,
        isLoading: true,
      ),
    );

    try {
      final models = await _repo.getModels(
        bodyTypeId: bodyTypeId,
        makeId: makeId,
      );
      emit(state.copyWith(models: models, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false));
    }
  }

  void clearFilters() => applyFilters();

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }

  Future<void> refresh() => applyFilters(
    bodyTypeId: state.selectedBodyTypeId,
    makeId: state.selectedMakeId,
  );
}
