part of 'search_cubit.dart';

class SearchState extends Equatable {
  const SearchState({
    this.results = const [],
    this.filters = const SearchFilters(),
    this.appErr,
    required this.searchTerm,
    required this.isBusy,
  });

  final String? searchTerm;
  final SearchFilters filters;
  final bool isBusy;
  final List<SearchResult> results;
  final BaseAppError? appErr;

  @override
  List<Object?> get props => [searchTerm, isBusy, results, filters, appErr];

  bool get isFailure => appErr != null;
  bool get hasResults => results.isNotEmpty;

  SearchState copyWith({
    String? searchTerm,
    bool? isBusy,
    List<SearchResult>? results,
    SearchFilters? filters,
    BaseAppError? appErr,
  }) {
    return SearchState(
      searchTerm: searchTerm ?? this.searchTerm,
      isBusy: isBusy ?? this.isBusy,
      results: results ?? this.results,
      filters: filters ?? this.filters,
      appErr: appErr ?? this.appErr,
    );
  }

  @override
  String toString() {
    return 'SearchState(searchTerm: $searchTerm, isBusy: $isBusy, results: ${results.length}, filters: $filters, appErr: $appErr)';
  }
}
