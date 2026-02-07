import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';

class HotTopicsState {
  const HotTopicsState({
    this.items = const [],
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = true,
    this.take = 10,
    this.query = '',
    this.hotOnly = false,
    this.error,
  });

  final List<HotTopic> items;
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final int take;
  final String query;
  final bool hotOnly;
  final Object? error;

  List<HotTopic> get filtered {
    Iterable<HotTopic> out = items;

    if (hotOnly) {
      out = out.where((t) => t.isHot);
    }

    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      out = out.where((t) {
        final name = '${t.makeName} ${t.name}'.toLowerCase();
        return name.contains(q);
      });
    }

    return out.toList();
  }

  HotTopicsState copyWith({
    List<HotTopic>? items,
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    int? take,
    String? query,
    bool? hotOnly,
    Object? error,
  }) {
    return HotTopicsState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      take: take ?? this.take,
      query: query ?? this.query,
      hotOnly: hotOnly ?? this.hotOnly,
      error: error,
    );
  }
}

class HotTopicsCubit extends Cubit<HotTopicsState> {
  HotTopicsCubit(this._repo) : super(const HotTopicsState());

  final CarDataRepository _repo;

  Future<void> loadInitial() async {
    emit(state.copyWith(loading: true, error: null, hasMore: true));
    try {
      final items = await _repo.getHotTopics(take: state.take, skip: 0);
      emit(
        state.copyWith(
          loading: false,
          items: items,
          hasMore: items.length == state.take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e));
    }
  }

  void setHotOnly(bool v) => emit(state.copyWith(hotOnly: v));

  Future<void> refresh() => loadInitial();

  Future<void> loadMore() async {
    // Guardrails:
    if (state.loading || state.loadingMore || !state.hasMore) return;
    // If you’re doing local search, don’t load more while searching:
    if (state.query.trim().isNotEmpty) return;

    emit(state.copyWith(loadingMore: true, error: null));
    try {
      final next = await _repo.getHotTopics(
        take: state.take,
        skip: state.items.length,
      );

      emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...next],
          hasMore: next.length == state.take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e));
    }
  }

  void setQuery(String q) => emit(state.copyWith(query: q));
}
