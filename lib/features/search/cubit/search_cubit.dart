import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/features/search/models/search_filters.dart';
import 'package:sham_cars/features/search/models/search_result.dart';
import 'package:sham_cars/features/search/repositories.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';

part 'search_state.dart';

const _initialState = SearchState(searchTerm: null, isBusy: false);

class SearchCubit extends Cubit<SearchState> {
  SearchRepository get _searchRepository => GetIt.I.get();
  late final BlocHelpers _helpers;
  late final searchTextController = TextEditingController();
  SearchCubit({SearchState initialState = _initialState})
    : super(initialState) {
    _helpers = BlocHelpers(
      emitProcessingRequest: () => emit(state.copyWith(isBusy: true)),
      setAsIdle: () => emit(state.copyWith(isBusy: false)),
      onError: (err) => emit(state.copyWith(appErr: err)),
      isBusy: () => state.isBusy,
    );
  }

  Future<void> _fetchResults() async {
    if (state.searchTerm?.isEmpty ?? true) {
      return;
    }
    emit(state.copyWith(isBusy: true));
    await Future.delayed(const Duration(seconds: 5));
    final results = List.generate(6, (index) => SearchResult.fakeMedFacility());
    emit(state.copyWith(isBusy: false, results: results));
    // _helpers.handleFuture(
    //   _searchRepository.searchFor(state.searchTerm!, state.filters),
    //   onSuccess: (results) =>
    //       emit(state.copyWith(isBusy: false, results: results)),
    // );
  }

  void searchFor(String searchTerm) {
    emit(state.copyWith(searchTerm: searchTerm));
    if (searchTerm.isNotEmpty) {
      _fetchResults();
    }
  }

  void setSearchCategory(SearchCategoryFilter categoryFilter) {
    emit(
      state.copyWith(
        filters: state.filters.copyWith(categoryFilter: categoryFilter),
      ),
    );
    _fetchResults();
  }

  void applyFilters(SearchFilters filters) {
    emit(state.copyWith(filters: filters));
    _fetchResults();
  }
}
