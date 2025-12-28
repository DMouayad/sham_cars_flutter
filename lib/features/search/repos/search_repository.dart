part of '../repositories.dart';

abstract base class SearchRepository {
  SearchResults searchFor(String searchTerm, SearchFilters filters) async {
    return (switch (filters.categoryFilter) {
      SearchCategoryFilter.all => _searchAll(searchTerm, filters),
      SearchCategoryFilter.doctors => _searchDoctors(searchTerm, filters),
      SearchCategoryFilter.facilities => _searchFacilities(searchTerm, filters),
    }).then(_decodeResponseBody);
  }

  // _handleError(Object error, StackTrace trace) {
  //   return switch (error) {
  //     AppError.notFound => SearchResults.value([]),
  //     _ => SearchResults.error(error)
  //   };
  // }

  Future<JsonObject> _searchAll(String searchTerm, SearchFilters filters);
  Future<JsonObject> _searchDoctors(String searchTerm, SearchFilters filters);
  Future<JsonObject> _searchFacilities(
    String searchTerm,
    SearchFilters filters,
  );

  List<SearchResult> _decodeResponseBody(JsonObject json);
}
