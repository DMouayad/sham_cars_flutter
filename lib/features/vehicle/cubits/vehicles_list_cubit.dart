import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import '../repositories/car_data_repository.dart';

class VehiclesListState {
  final List<CarTrimSummary> trims;
  final List<BodyType> bodyTypes;
  final List<CarMake> makes;
  final TrimFilters filters;
  final bool isLoading;
  final bool isFiltersLoading;
  final bool isLoadingMore;
  final Object? error;
  final bool hasMore;

  const VehiclesListState({
    this.trims = const [],
    this.bodyTypes = const [],
    this.makes = const [],
    this.filters = const TrimFilters(take: 20),
    this.isLoading = false,
    this.isFiltersLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
  });

  VehiclesListState copyWith({
    List<CarTrimSummary>? trims,
    List<BodyType>? bodyTypes,
    List<CarMake>? makes,
    TrimFilters? filters,
    bool? isLoading,
    bool? isFiltersLoading,
    bool? isLoadingMore,
    Object? error,
    bool? hasMore,
    bool clearError = false,
  }) {
    return VehiclesListState(
      trims: trims ?? this.trims,
      bodyTypes: bodyTypes ?? this.bodyTypes,
      makes: makes ?? this.makes,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      isFiltersLoading: isFiltersLoading ?? this.isFiltersLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  BodyType? get selectedBodyType =>
      bodyTypes.where((b) => b.id == filters.bodyTypeId).firstOrNull;

  CarMake? get selectedMake =>
      makes.where((m) => m.id == filters.makeId).firstOrNull;
}

class VehiclesListCubit extends Cubit<VehiclesListState> {
  final CarDataRepository _repo;
  static const _pageSize = 20;

  VehiclesListCubit(this._repo) : super(const VehiclesListState());

  Future<void> init() async {
    emit(state.copyWith(isFiltersLoading: true, isLoading: true));

    try {
      await RestClient.runCached(() async {
        final results = await Future.wait([
          _repo.getBodyTypes(),
          _repo.getMakes(),
          _repo.getTrims(state.filters),
        ]);

        emit(
          state.copyWith(
            bodyTypes: results[0] as List<BodyType>,
            makes: results[1] as List<CarMake>,
            trims: results[2] as List<CarTrimSummary>,
            isFiltersLoading: false,
            isLoading: false,
            hasMore: (results[2] as List).length >= _pageSize,
          ),
        );
      });
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false, isFiltersLoading: false));
    }
  }

  Future<void> search(String query) async {
    final newFilters = state.filters.copyWith(
      search: query.isEmpty ? null : query,
      clearSearch: query.isEmpty,
      skip: 0,
    );
    await _applyFilters(newFilters);
  }

  Future<void> setMake(int? makeId) async {
    final newFilters = state.filters.copyWith(
      makeId: makeId,
      clearMake: makeId == null,
      skip: 0,
    );
    await _applyFilters(newFilters);
  }

  Future<void> setBodyType(int? bodyTypeId) async {
    final newFilters = state.filters.copyWith(
      bodyTypeId: bodyTypeId,
      clearBodyType: bodyTypeId == null,
      skip: 0,
    );
    await _applyFilters(newFilters);
  }

  Future<void> setPriceRange(int? min, int? max) async {
    final newFilters = state.filters.copyWith(
      minPrice: min,
      maxPrice: max,
      clearPrice: min == null && max == null,
      skip: 0,
    );
    await _applyFilters(newFilters);
  }

  Future<void> setMinRange(int? minRangeKm) async {
    final newFilters = state.filters.copyWith(
      minRangeKm: minRangeKm,
      clearRange: minRangeKm == null,
      skip: 0,
    );
    await _applyFilters(newFilters);
  }

  Future<void> setSeats(int? seats) async {
    final newFilters = state.filters.copyWith(
      seats: seats,
      clearSeats: seats == null,
      skip: 0,
    );
    await _applyFilters(newFilters);
  }

  Future<void> applyFilters(TrimFilters filters) async {
    await _applyFilters(filters.copyWith(skip: 0));
  }

  Future<void> _applyFilters(TrimFilters filters) async {
    emit(state.copyWith(filters: filters, isLoading: true, clearError: true));

    try {
      final trims = await _repo.getTrims(filters);
      emit(
        state.copyWith(
          trims: trims,
          isLoading: false,
          hasMore: trims.length >= _pageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final newFilters = state.filters.copyWith(skip: state.trims.length);
      final moreTrims = await _repo.getTrims(newFilters);

      emit(
        state.copyWith(
          trims: [...state.trims, ...moreTrims],
          isLoadingMore: false,
          hasMore: moreTrims.length >= _pageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> clearFilters() async {
    await _applyFilters(state.filters.clear());
  }

  Future<void> refresh() async {
    await _applyFilters(state.filters.copyWith(skip: 0));
  }
}
