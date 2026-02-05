import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';

class SimilarTrimsState {
  final bool loadingInitial;
  final String? error;

  final List<CarTrimSummary> items;
  final bool loadingMore;
  final bool hasMore;
  final int skip;

  const SimilarTrimsState({
    this.loadingInitial = false,
    this.error,
    this.items = const [],
    this.loadingMore = false,
    this.hasMore = true,
    this.skip = 0,
  });

  SimilarTrimsState copyWith({
    bool? loadingInitial,
    String? error,
    List<CarTrimSummary>? items,
    bool? loadingMore,
    bool? hasMore,
    int? skip,
    bool clearError = false,
  }) {
    return SimilarTrimsState(
      loadingInitial: loadingInitial ?? this.loadingInitial,
      error: clearError ? null : (error ?? this.error),
      items: items ?? this.items,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
    );
  }
}

class SimilarTrimsCubit extends Cubit<SimilarTrimsState> {
  SimilarTrimsCubit(this._repo) : super(const SimilarTrimsState());
  final CarDataRepository _repo;

  static const int _take = 5;
  int? _trimId;

  Future<void> load(int trimId) async {
    _trimId = trimId;

    emit(
      state.copyWith(
        loadingInitial: true,
        clearError: true,
        items: const [],
        skip: 0,
        hasMore: true,
      ),
    );

    try {
      final items = await _repo.getSimilarTrims(trimId, take: _take, skip: 0);
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
    if (_trimId == null) return;
    if (state.loadingInitial || state.loadingMore || !state.hasMore) return;

    emit(state.copyWith(loadingMore: true));

    try {
      final next = await _repo.getSimilarTrims(
        _trimId!,
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
    } catch (_) {
      emit(state.copyWith(loadingMore: false));
    }
  }
}
