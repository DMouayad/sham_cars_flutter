import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sham_cars/utils/utils.dart';

enum SearchCategoryFilter {
  all,
  doctors,
  facilities;

  String getMessage(BuildContext context) {
    return switch (this) {
      SearchCategoryFilter.doctors => context.l10n.doctorSearchFilter,
      SearchCategoryFilter.facilities => context.l10n.facilitySearchFilter,
      SearchCategoryFilter.all => context.l10n.allSearchFilter,
    };
  }

  String asUrlParam() {
    return switch (this) {
      SearchCategoryFilter.doctors => 'physician',
      SearchCategoryFilter.facilities => 'facilities',
      SearchCategoryFilter.all => 'physician, facilities',
    };
  }
}

final class SearchFilters extends Equatable {
  final SearchFilter? cityFilter;
  final SearchFilter? specialtyFilter;
  final SearchCategoryFilter categoryFilter;

  String asUrlParam({required bool withCategory}) {
    var parts = <String>[];
    if (withCategory) {
      parts.add('type=${categoryFilter.asUrlParam()}');
    }
    if (categoryFilter != SearchCategoryFilter.facilities &&
        specialtyFilter != null) {
      parts.add(specialtyFilter!.asUrlParam());
    }
    if (cityFilter != null) {
      parts.add(cityFilter!.asUrlParam());
    }
    return parts.join("&");
  }

  const SearchFilters({
    this.cityFilter,
    this.specialtyFilter,
    this.categoryFilter = SearchCategoryFilter.all,
  });
  SearchFilters copyWith({
    SearchFilter? cityFilter,
    SearchFilter? specialtyFilter,
    SearchCategoryFilter? categoryFilter,
  }) {
    return SearchFilters(
      cityFilter: cityFilter ?? this.cityFilter,
      specialtyFilter: specialtyFilter ?? this.specialtyFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
    );
  }

  @override
  List<Object?> get props => [cityFilter, specialtyFilter, categoryFilter];

  static SearchFilters? fromJson(Map<String, dynamic>? json) {
    SearchFilter? cityFilter;
    SearchFilter? specialtyFilter;

    if (json?['cityFilter'] case (Map<String, dynamic> city)) {
      cityFilter = SearchFilter.fromJson(city);
    }
    if (json?['specialtyFilter'] case (Map<String, dynamic> specialty)) {
      specialtyFilter = SearchFilter.fromJson(specialty);
    }

    var categoryFilter = SearchCategoryFilter.all;
    if (json?['categoryFilter'] case String categoryFilterName) {
      if (SearchCategoryFilter.values.asNameMap().keys.contains(
        categoryFilterName,
      )) {
        categoryFilter = SearchCategoryFilter.values.byName(categoryFilterName);
      }
    }
    return SearchFilters(
      cityFilter: cityFilter,
      specialtyFilter: specialtyFilter,
      categoryFilter: categoryFilter,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (cityFilter != null) "cityFilter": cityFilter?.toJson(),
      if (specialtyFilter != null) "specialtyFilter": specialtyFilter?.toJson(),
      "categoryFilter": categoryFilter.name,
    };
  }
}

final class SearchFilter extends Equatable {
  final String filterValue;
  final String filterName;

  const SearchFilter._({required this.filterValue, required this.filterName});
  static const cityFilterName = 'city';
  static const specialtyFilterName = 'specialty';

  factory SearchFilter.specialtyFilter({
    required String filterValue,
    bool asc = true,
  }) {
    return SearchFilter._(
      filterValue: filterValue,
      filterName: specialtyFilterName,
    );
  }

  factory SearchFilter.cityFilter({
    required String filterValue,
    bool asc = true,
  }) {
    return SearchFilter._(filterValue: filterValue, filterName: cityFilterName);
  }

  Map<String, dynamic> toJson() {
    return {"filterValue": filterValue, "filterName": filterName};
  }

  static SearchFilter? fromJson(Map<String, dynamic>? json) {
    if (json
        case ({
              "filterName": String filterName,
              "filterValue": String filterValue,
            })) {
      return SearchFilter._(filterValue: filterValue, filterName: filterName);
    }
    return null;
  }

  String asUrlParam() {
    return '$filterName=$filterValue';
  }

  @override
  List<Object?> get props => [filterName, filterValue];
}
