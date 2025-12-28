import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:sham_cars/features/home/components/home_section.dart';
import 'package:sham_cars/features/home/components/nearby_facilities_section.dart';
import 'package:sham_cars/features/search/cubit/search_cubit.dart';
import 'package:sham_cars/features/search/models/search_result.dart';
import 'package:sham_cars/features/search/widgets/search_filters_section.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/features/search/widgets/search_card_wrapper.dart';
import 'package:sham_cars/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sheetController = DraggableScrollableController();
  final ValueNotifier<double> _opacityNotifier = ValueNotifier(1.0);
  var initialChildSize = .7;
  bool sheetIsOpening = false;

  @override
  void initState() {
    sheetController.addListener(() {
      // Update opacity based on scroll offset
      if (!sheetIsOpening && sheetController.size < initialChildSize) {
        double opacity = sheetController.size;
        _opacityNotifier.value = opacity;
      }
      if (sheetController.size == initialChildSize) {
        _opacityNotifier.value = 1;
      }
    });
    super.initState();
  }

  SearchResult? selectedResult;

  Future<void> hideSheet() async {
    if (selectedResult == null) {
      return;
    }

    selectedResult = null;
    await sheetController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
    _opacityNotifier.value = 1;
    setState(() {});
  }

  Future<void> showSheet(SearchResult result) async {
    sheetIsOpening = true;
    setState(() => selectedResult = result);
    await Future.delayed(const Duration(milliseconds: 50));
    await sheetController.animateTo(
      initialChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastLinearToSlowEaseIn,
    );
    sheetIsOpening = false;
  }

  @override
  void dispose() {
    sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        PinnedHeaderSliver(
          child: Container(
            color: context.colorScheme.surface,
            child: _PinnedSearchSec(context.read()),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state.isBusy || state.hasResults) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    itemBuilder: (context, i) {
                      return AnimatedSwitcher(
                        key: Key('search-result-card-$i'),
                        duration: Duration(milliseconds: 300 * i),
                        child: state.isBusy
                            ? const _CardSkeleton()
                            : SearchCardWrapper(
                                result: state.results[i],
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  showSheet(state.results[i]);
                                },
                              ),
                      );
                    },
                    separatorBuilder: (context, _) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      );
                    },
                    itemCount: state.isBusy ? 4 : state.results.length,
                  );
                }
                return const SizedBox(height: 22);
              },
            ),
            HomeScreenSection(
              title: context.l10n.homeFacilitiesSectionTitle,
              content: const NearbyFacilitiesSection(),
            ),
          ]),
        ),
      ],
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(6);
    return Skeletonizer.zone(
      child: Card(
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // flex: 0,
              child: Bone.square(
                size: 44,
                borderRadius: BorderRadius.circular(4),
                indentEnd: 16,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(width: 120, fontSize: 14, borderRadius: borderRadius),
                const SizedBox(height: 5),
                Bone.text(width: 50, borderRadius: borderRadius),
                const SizedBox(height: 5),
                Bone.text(fontSize: 10, width: 240, borderRadius: borderRadius),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PinnedSearchSec extends StatefulWidget {
  const _PinnedSearchSec(this.searchCubit);
  final SearchCubit searchCubit;

  @override
  State<_PinnedSearchSec> createState() => _PinnedSearchSecState();
}

class _PinnedSearchSecState extends State<_PinnedSearchSec> {
  bool showFilters = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAnchor(
          builder: (context, controller) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: _SearchBar(onTap: () => setState(() => showFilters = true)),
          ),
          isFullScreen: false,
          suggestionsBuilder: (context, controller) => [],
        ),
        AnimatedCrossFade(
          firstChild: SearchFiltersSection(widget.searchCubit),
          secondChild: const SizedBox.shrink(),
          crossFadeState: showFilters
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
        if (showFilters)
          const SizedBox(
            width: 100,
            child: Divider(color: AppTheme.lightGreyColor),
          ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      onTap: onTap,
      autoFocus: false,
      controller: context.read<SearchCubit>().searchTextController,
      hintText: context.l10n.homeSearchBarHint,
      hintStyle: WidgetStatePropertyAll(
        context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurface,
        ),
      ),
      onSubmitted: context.read<SearchCubit>().searchFor,
      leading: const Icon(Icons.search),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      trailing: [
        ListenableBuilder(
          listenable: context.read<SearchCubit>().searchTextController,
          builder: (context, child) {
            final controller = context.read<SearchCubit>().searchTextController;
            return controller.text.isNotEmpty
                ? child!
                : const SizedBox.shrink();
          },
          child: IconButton(
            onPressed: () {
              context.read<SearchCubit>().searchTextController.text = "";
              context.read<SearchCubit>().searchFor("");
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ],
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: context.colorScheme.primary);
        }
        return BorderSide(color: context.colorScheme.outline);
      }),
      elevation: const WidgetStatePropertyAll(0),
    );
  }
}
