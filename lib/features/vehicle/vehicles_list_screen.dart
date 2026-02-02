import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/widgets/trim_card.dart';
import 'package:sham_cars/utils/utils.dart';

import 'cubits/vehicles_list_cubit.dart';
import 'models.dart';

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<VehiclesListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehiclesListCubit, VehiclesListState>(
      builder: (context, state) {
        if (state.error != null && state.trims.isEmpty) {
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
              // Search
              PinnedHeaderSliver(
                child: Container(
                  color: context.colorScheme.surface,
                  padding: const EdgeInsets.all(ThemeConstants.p),
                  child: Column(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (q) {
                          _debouncer.run(() {
                            context.read<VehiclesListCubit>().search(q);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'ابحث عن سيارة...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<VehiclesListCubit>().search(
                                      '',
                                    );
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              ThemeConstants.rCard,
                            ),
                          ),
                          filled: true,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChipsRow(
                              state: state,
                              onFilterTap: () =>
                                  _showFiltersSheet(context, state),
                            ),
                            Icon(
                              Icons.directions_car,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${state.trims.length} سيارة',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            if (state.isLoading) ...[
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Grid
              if (state.trims.isEmpty)
                const SliverFillRemaining(child: _EmptyView())
              else if (state.isLoading && state.trims.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.p,
                  ),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemCount:
                        state.trims.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i >= state.trims.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final trim = state.trims[i];
                      return TrimCard(
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

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({required this.state, required this.onFilterTap});

  final VehiclesListState state;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
      child: Row(
        children: [
          // Filter button
          ActionChip(
            avatar: Badge(
              isLabelVisible: state.filters.hasFilters,
              smallSize: 8,
              child: const Icon(Icons.tune, size: 18),
            ),
            label: const Text('الفلاتر'),
            onPressed: onFilterTap,
          ),
          const SizedBox(width: 8),

          // Active filter chips
          if (state.selectedMake case final make?)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Chip(
                label: Text(make.name),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () =>
                    context.read<VehiclesListCubit>().setMake(null),
              ),
            ),

          if (state.selectedBodyType case final bt?)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Chip(
                avatar: Text(bt.icon),
                label: Text(bt.name),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () =>
                    context.read<VehiclesListCubit>().setBodyType(null),
              ),
            ),

          if (state.filters.minRangeKm case final range?)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Chip(
                label: Text('$range+ كم'),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () =>
                    context.read<VehiclesListCubit>().setMinRange(null),
              ),
            ),
          if (state.filters.seats case final seats?)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Chip(
                label: Text('$seats+ مقاعد'),
                deleteIcon: const Icon(Icons.close, size: 16),
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
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            'جرب تغيير الفلاتر',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.outline),
          ),
        ],
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
