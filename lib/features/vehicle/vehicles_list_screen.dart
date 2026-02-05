import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/theme/constants.dart';

import 'cubits/vehicles_list_cubit.dart';
import 'models.dart';
import 'widgets/list_trim_card.dart';
import '../questions/widgets/trim_card_skeleton.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key, required this.onOpenTrim});
  final void Function(CarTrimSummary summary) onOpenTrim;

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = _Debouncer(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<VehiclesListCubit>();
    final st = cubit.state;

    if (st.isLoading || st.isLoadingMore || !st.hasMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 250) {
      cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<VehiclesListCubit, VehiclesListState>(
      builder: (context, state) {
        final isEmpty = state.trims.isEmpty;

        if (state.error != null && isEmpty) {
          return _ErrorView(
            error: state.error!,
            onRetry: () => context.read<VehiclesListCubit>().init(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<VehiclesListCubit>().refresh(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Pinned header: Search + filter actions + chips (minimal height)
              PinnedHeaderSliver(
                child: Container(
                  color: cs.surface,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    ThemeConstants.p,
                    10,
                    ThemeConstants.p,
                    10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SearchField(
                        controller: _searchController,
                        onChanged: (q) => _debouncer.run(() {
                          context.read<VehiclesListCubit>().search(q);
                        }),
                        onClear: () {
                          _searchController.clear();
                          context.read<VehiclesListCubit>().search('');
                          setState(() {}); // ensures suffix icon updates
                        },
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => _showFiltersSheet(context, state),
                            icon: Badge(
                              isLabelVisible:
                                  state.filters.activeFilterCount > 0,
                              label: Text('${state.filters.activeFilterCount}'),
                              child: const Icon(Icons.tune),
                            ),
                            label: const Text('الفلاتر'),
                          ),
                          const SizedBox(width: 8),

                          if (state.filters.hasFilters)
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                context
                                    .read<VehiclesListCubit>()
                                    .clearFilters();
                                setState(() {});
                              },
                              child: const Text('مسح'),
                            ),

                          const Spacer(),

                          if (state.isLoading)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),

                      if (state.filters.hasFilters) ...[
                        const SizedBox(height: 8),
                        _ActiveFiltersRow(state: state),
                      ],

                      if (!state.isLoading && state.filters.hasFilters) ...[
                        const SizedBox(height: 6),
                        Text(
                          'النتائج: ${state.trims.length}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Body
              if (state.isLoading && state.trims.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(ThemeConstants.p),
                  sliver: SliverList.separated(
                    itemCount: 6,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, _) => const TrimListCardSkeleton(),
                  ),
                )
              else if (!state.isLoading && isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyView(
                    onClear: state.filters.hasFilters
                        ? () {
                            _searchController.clear();
                            context.read<VehiclesListCubit>().clearFilters();
                            setState(() {});
                          }
                        : null,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(ThemeConstants.p),
                  sliver: SliverList.separated(
                    itemCount:
                        state.trims.length + (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      if (i >= state.trims.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      final trim = state.trims[i];
                      return TrimListCard(
                        trim: trim,
                        onTap: () => widget.onOpenTrim(trim),
                      );
                    },
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  void _showFiltersSheet(BuildContext context, VehiclesListState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _FiltersSheet(
        bodyTypes: state.bodyTypes,
        makes: state.makes,
        filters: state.filters,
        onApply: (filters) {
          context.read<VehiclesListCubit>().applyFilters(filters);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'ابحث عن سيارة...',
        isDense: true,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.rCard),
        ),
        filled: true,
      ),
    );
  }
}

class _ActiveFiltersRow extends StatelessWidget {
  const _ActiveFiltersRow({required this.state});
  final VehiclesListState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (state.selectedMake case final make?)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: InputChip(
                label: Text(make.name),
                onDeleted: () =>
                    context.read<VehiclesListCubit>().setMake(null),
              ),
            ),
          if (state.selectedBodyType case final bt?)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: InputChip(
                avatar: Text(bt.icon),
                label: Text(bt.name),
                onDeleted: () =>
                    context.read<VehiclesListCubit>().setBodyType(null),
              ),
            ),
          if (state.filters.minRangeKm case final range?)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: InputChip(
                label: Text('$range+ كم'),
                onDeleted: () =>
                    context.read<VehiclesListCubit>().setMinRange(null),
              ),
            ),
          if (state.filters.seats case final seats?)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: InputChip(
                label: Text('$seats+ مقاعد'),
                onDeleted: () =>
                    context.read<VehiclesListCubit>().setSeats(null),
              ),
            ),
        ],
      ),
    );
  }
}

class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({
    required this.bodyTypes,
    required this.makes,
    required this.filters,
    required this.onApply,
  });

  final List<BodyType> bodyTypes;
  final List<CarMake> makes;
  final TrimFilters filters;
  final void Function(TrimFilters) onApply;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late TrimFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.p),
            child: Row(
              children: [
                Text(
                  'الفلاتر',
                  style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => _filters = _filters.clear()),
                  child: const Text('مسح الكل'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(ThemeConstants.p),
              children: [
                // Makes
                _FilterSection(
                  title: 'العلامة التجارية',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.makes.map((make) {
                      final selected = _filters.makeId == make.id;
                      return ChoiceChip(
                        label: Text(make.name),
                        selected: selected,
                        onSelected: (s) => setState(() {
                          _filters = _filters.copyWith(
                            makeId: s ? make.id : null,
                            clearMake: !s,
                          );
                        }),
                      );
                    }).toList(),
                  ),
                ),

                // Body Types
                _FilterSection(
                  title: 'نوع الهيكل',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.bodyTypes.map((bt) {
                      final selected = _filters.bodyTypeId == bt.id;
                      return ChoiceChip(
                        avatar: Text(bt.icon),
                        label: Text(bt.name),
                        selected: selected,
                        onSelected: (s) => setState(() {
                          _filters = _filters.copyWith(
                            bodyTypeId: s ? bt.id : null,
                            clearBodyType: !s,
                          );
                        }),
                      );
                    }).toList(),
                  ),
                ),

                // Range
                _FilterSection(
                  title: 'المدى الأدنى',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [200, 300, 400, 500, 600].map((range) {
                      final selected = _filters.minRangeKm == range;
                      return ChoiceChip(
                        label: Text('$range+ كم'),
                        selected: selected,
                        onSelected: (s) => setState(() {
                          _filters = _filters.copyWith(
                            minRangeKm: s ? range : null,
                            clearRange: !s,
                          );
                        }),
                      );
                    }).toList(),
                  ),
                ),

                // Seats
                _FilterSection(
                  title: 'عدد المقاعد',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [2, 4, 5, 7].map((seats) {
                      final selected = _filters.seats == seats;
                      return ChoiceChip(
                        label: Text('$seats+'),
                        selected: selected,
                        onSelected: (s) => setState(() {
                          _filters = _filters.copyWith(
                            seats: s ? seats : null,
                            clearSeats: !s,
                          );
                        }),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.only(
              left: ThemeConstants.p,
              right: ThemeConstants.p,
              bottom: MediaQuery.of(context).padding.bottom + ThemeConstants.p,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => widget.onApply(_filters),
                child: const Text('تطبيق'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({this.onClear});
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.p),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_car_outlined, size: 64, color: cs.outline),
            const SizedBox(height: 16),
            Text(
              'لا توجد سيارات',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              'جرّب تغيير الفلاتر أو البحث',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.outline),
              textAlign: TextAlign.center,
            ),
            if (onClear != null) ...[
              const SizedBox(height: 14),
              FilledButton.tonal(
                onPressed: onClear,
                child: const Text('مسح الفلاتر'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text('حدث خطأ', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class _Debouncer {
  final int milliseconds;
  Timer? _timer;

  _Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
