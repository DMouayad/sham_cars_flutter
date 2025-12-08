import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sham_cars/features/search/cubit/search_cubit.dart';
import 'package:sham_cars/features/search/models/search_filters.dart';
import 'package:sham_cars/features/search/widgets/search_filter_chip.dart';
import 'package:sham_cars/utils/src/constants.dart';
import 'package:sham_cars/utils/utils.dart';

class SearchFiltersSection extends StatefulWidget {
  const SearchFiltersSection(this.searchCubit, {super.key});
  final SearchCubit searchCubit;

  @override
  State<SearchFiltersSection> createState() => _SearchFilterStatesSection();
}

class _SearchFilterStatesSection extends State<SearchFiltersSection> {
  SearchFilters filters = const SearchFilters();

  @override
  void initState() {
    filters = widget.searchCubit.state.filters;
    super.initState();
  }

  void setCategoryFilter(SearchCategoryFilter category) {
    setState(() => filters = filters.copyWith(categoryFilter: category));
  }

  void setCityFilter(String? cityName) {
    setState(() {
      filters = filters.copyWith(
        cityFilter: cityName != null
            ? SearchFilter.cityFilter(filterValue: cityName)
            : null,
      );
    });
  }

  void setSpecialtyFilter(String? specialty) {
    setState(() {
      filters = filters.copyWith(
        specialtyFilter: specialty != null
            ? SearchFilter.specialtyFilter(filterValue: specialty)
            : null,
      );
    });
  }

  void clearCityFilter() {
    setState(() {
      filters = SearchFilters(specialtyFilter: filters.specialtyFilter);
    });
  }

  void clearSpecialtyFilter() {
    setState(() {
      filters = SearchFilters(cityFilter: filters.cityFilter);
    });
  }

  List<PopupMenuEntry<T>> getItems<T>(
    List<T> values,
    String Function(T item) getItemText,
  ) {
    return values
        .map((e) => PopupMenuItem(value: e, child: Text(getItemText(e))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      side: BorderSide(color: context.colorScheme.onSurface),
      borderRadius: BorderRadius.circular(20),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                PopupMenuButton(
                  elevation: 1,
                  shape: border,
                  initialValue: filters.categoryFilter,
                  onSelected: setCategoryFilter,
                  itemBuilder: (context) => getItems(
                    SearchCategoryFilter.values,
                    (e) => e.getMessage(context),
                  ),
                  child: SearchFilterChip(
                    avatarIcon: Icons.filter_alt_outlined,
                    label: context.l10n.categorySearchFilterPopupLabel,
                    value: filters.categoryFilter.getMessage(context),
                  ),
                ),
                PopupMenuButton<String>(
                  elevation: 1,
                  shape: border,
                  initialValue: filters.cityFilter?.filterValue,
                  onSelected: setCityFilter,
                  itemBuilder: (context) => getItems(kCities, (e) => e),
                  child: SearchFilterChip(
                    avatarIcon: Icons.location_city,
                    onDeleted: clearCityFilter,
                    value: filters.cityFilter?.filterValue,
                    label: context.l10n.citySearchFilterPopupLabel,
                  ),
                ),
                if (filters.categoryFilter != SearchCategoryFilter.facilities)
                  PopupMenuButton<String>(
                    elevation: 1,
                    shape: border,
                    initialValue: filters.specialtyFilter?.filterValue,
                    onSelected: setSpecialtyFilter,
                    itemBuilder: (context) =>
                        getItems(kMedicalSpecialties.toList(), (e) => e),
                    child: SearchFilterChip(
                      avatarIcon: Icons.medical_services,
                      onDeleted: clearSpecialtyFilter,
                      value: filters.specialtyFilter?.filterValue,
                      label: context.l10n.specialtySearchFilterPopupLabel,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: BlocBuilder<SearchCubit, SearchState>(
              bloc: widget.searchCubit,
              buildWhen: (prev, current) =>
                  prev.filters != current.filters ||
                  (prev.isBusy != current.isBusy),
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state.filters != filters) ...[
                      TextButton(
                        onPressed: () =>
                            setState(() => filters = state.filters),
                        child: Text(context.l10n.cancel),
                      ),
                      FilledButton(
                        onPressed: state.isBusy
                            ? null
                            : () {
                                widget.searchCubit.applyFilters(filters);
                                FocusScope.of(context).unfocus();
                              },
                        child: Text(context.l10n.applyFilters),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
