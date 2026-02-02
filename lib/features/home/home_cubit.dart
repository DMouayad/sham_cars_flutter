import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/vehicle/models.dart';

import 'home_repository.dart';
import 'models.dart';

class HomeState {
  final HomeData? data;
  final bool isLoading;
  final Object? error;
  final String searchQuery;
  final List<CarTrimSummary> searchResults;
  final bool isSearching;

  const HomeState({
    this.data,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
  });

  HomeState copyWith({
    HomeData? data,
    bool? isLoading,
    Object? error,
    String? searchQuery,
    List<CarTrimSummary>? searchResults,
    bool? isSearching,
    bool clearError = false,
  }) {
    return HomeState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  bool get hasData => data != null;
  bool get showSearchResults => searchQuery.isNotEmpty;
}

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repo;

  HomeCubit(this._repo) : super(const HomeState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final data = await _repo.getHomeData();
      emit(state.copyWith(data: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false));
    }
  }

  Future<void> refresh() async {
    try {
      final data = await _repo.getHomeData(forceRefresh: true);
      emit(state.copyWith(data: data));
    } catch (e) {
      // Keep old data on refresh error
      emit(state.copyWith(error: e));
    }
  }

  Future<void> search(String query) async {
    emit(state.copyWith(searchQuery: query));

    if (query.trim().isEmpty) {
      emit(state.copyWith(searchResults: [], isSearching: false));
      return;
    }

    emit(state.copyWith(isSearching: true));
    try {
      final results = await _repo.search(query);
      // Only update if query hasn't changed
      if (state.searchQuery == query) {
        emit(state.copyWith(searchResults: results, isSearching: false));
      }
    } catch (e) {
      emit(state.copyWith(isSearching: false));
    }
  }

  void clearSearch() {
    emit(
      state.copyWith(searchQuery: '', searchResults: [], isSearching: false),
    );
  }
}
