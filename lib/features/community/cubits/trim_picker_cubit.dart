import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';

class TrimPickerState {
  final bool loadingInitial;
  final bool loadingMore;
  final String? error;

  final List<CarTrimSummary> items;
  final bool hasMore;
  final int skip;
  final String query;

  const TrimPickerState({
    this.loadingInitial = false,
    this.loadingMore = false,
    this.error,
    this.items = const [],
    this.hasMore = true,
    this.skip = 0,
    this.query = '',
  });

  TrimPickerState copyWith({
    bool? loadingInitial,
    bool? loadingMore,
    String? error,
    List<CarTrimSummary>? items,
    bool? hasMore,
    int? skip,
    String? query,
    bool clearError = false,
  }) {
    return TrimPickerState(
      loadingInitial: loadingInitial ?? this.loadingInitial,
      loadingMore: loadingMore ?? this.loadingMore,
      error: clearError ? null : (error ?? this.error),
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      query: query ?? this.query,
    );
  }
}

class TrimPickerCubit extends Cubit<TrimPickerState> {
  TrimPickerCubit(this._repo) : super(const TrimPickerState());
  final CarDataRepository _repo;

  static const _take = 15;

  Future<void> loadInitial({String query = ''}) async {
    emit(
      state.copyWith(
        loadingInitial: true,
        clearError: true,
        items: const [],
        skip: 0,
        hasMore: true,
        query: query,
      ),
    );

    try {
      final items = await _repo.getTrimsPage(
        search: query.isEmpty ? null : query,
        take: _take,
        skip: 0,
      );

      emit(
        state.copyWith(
          loadingInitial: false,
          items: items,
          skip: items.length,
          hasMore: items.length == _take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingInitial: false, error: e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (state.loadingInitial || state.loadingMore || !state.hasMore) return;

    emit(state.copyWith(loadingMore: true, clearError: true));

    try {
      final next = await _repo.getTrimsPage(
        search: state.query.isEmpty ? null : state.query,
        take: _take,
        skip: state.skip,
      );

      emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...next],
          skip: state.skip + next.length,
          hasMore: next.length == _take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e.toString()));
    }
  }

  void search(String q) => loadInitial(query: q);
}
