import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';

class TrendingCarsState {
  const TrendingCarsState({
    this.items = const [],
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = true,
    this.error,
  });

  final List<CarTrimSummary> items;
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final Object? error;

  TrendingCarsState copyWith({
    List<CarTrimSummary>? items,
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    Object? error,
  }) {
    return TrendingCarsState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class TrendingCarsCubit extends Cubit<TrendingCarsState> {
  TrendingCarsCubit(this._repo) : super(const TrendingCarsState());

  final CarDataRepository _repo;
  static const int _take = 20;

  Future<void> loadInitial() async {
    emit(
      state.copyWith(
        loading: true,
        error: null,
        items: const [],
        hasMore: true,
      ),
    );
    try {
      final items = await _repo.getTrendingCars(take: _take, skip: 0);
      emit(
        state.copyWith(
          loading: false,
          items: items,
          hasMore: items.length == _take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e));
    }
  }

  Future<void> refresh() => loadInitial();

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;

    emit(state.copyWith(loadingMore: true));
    try {
      final next = await _repo.getTrendingCars(
        take: _take,
        skip: state.items.length,
      );
      emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...next],
          hasMore: next.length == _take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e));
    }
  }
}
