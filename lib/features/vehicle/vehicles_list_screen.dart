import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/utils.dart';

import 'cubits/vehicles_list_cubit.dart';
import 'models.dart';
import 'widgets/vehicle_card.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key, required this.onOpenModel});

  final void Function(int modelId) onOpenModel;

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehiclesListCubit, VehiclesListState>(
      builder: (context, state) {
        if (state.error != null && state.models.isEmpty) {
          return _ErrorView(
            error: state.error!,
            onRetry: () => context.read<VehiclesListCubit>().init(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<VehiclesListCubit>().refresh(),
          child: CustomScrollView(
            slivers: [
              // Search
              PinnedHeaderSliver(
                child: Container(
                  color: context.colorScheme.surface,
                  padding: const EdgeInsets.all(ThemeConstants.p),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (q) =>
                            context.read<VehiclesListCubit>().search(q),
                        decoration: InputDecoration(
                          hintText: 'ابحث عن سيارة...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _searchController.clear();
                                    context
                                        .read<VehiclesListCubit>()
                                        .clearSearch();
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

                      Row(
                        children: [
                          _FiltersRow(
                            state: state,
                            onFilterTap: () =>
                                _showFiltersSheet(context, state),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.directions_car,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${state.filteredModels.length} سيارة',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Grid
              if (state.isLoading && state.models.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox.square(
                      dimension: 25,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else if (state.filteredModels.isEmpty)
                const SliverFillRemaining(child: _EmptyView())
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
                          childAspectRatio: 0.75,
                          mainAxisExtent: 250,
                        ),
                    itemCount: state.filteredModels.length,
                    itemBuilder: (_, i) {
                      final model = state.filteredModels[i];
                      return EnrichedModelCard(
                        model: model,
                        onTap: () => widget.onOpenModel(model.id),
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
        selectedBodyTypeId: state.selectedBodyTypeId,
        selectedMakeId: state.selectedMakeId,
        onApply: (bodyTypeId, makeId) {
          context.read<VehiclesListCubit>().applyFilters(
            bodyTypeId: bodyTypeId,
            makeId: makeId,
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({required this.state, required this.onFilterTap});

  final VehiclesListState state;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
      child: Row(
        children: [
          // Filter button
          ActionChip(
            avatar: const Icon(Icons.tune, size: 18),
            label: const Text('الفلاتر'),
            onPressed: onFilterTap,
          ),
          const SizedBox(width: 8),

          // Active filters as chips
          if (state.selectedMake case final make?)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: RawChip(
                onPressed: onFilterTap,
                label: Text(make.name),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => context.read<VehiclesListCubit>().applyFilters(
                  bodyTypeId: state.selectedBodyTypeId,
                ),
              ),
            ),

          if (state.selectedBodyType case final bodyType?)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: RawChip(
                onPressed: onFilterTap,
                avatar: bodyType.icon.isEmpty ? null : Text(bodyType.icon),
                label: Text(bodyType.name),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => context.read<VehiclesListCubit>().applyFilters(
                  makeId: state.selectedMakeId,
                ),
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
    required this.selectedBodyTypeId,
    required this.selectedMakeId,
    required this.onApply,
  });

  final List<BodyType> bodyTypes;
  final List<CarMake> makes;
  final int? selectedBodyTypeId;
  final int? selectedMakeId;
  final void Function(int? bodyTypeId, int? makeId) onApply;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  int? _bodyTypeId;
  int? _makeId;

  @override
  void initState() {
    super.initState();
    _bodyTypeId = widget.selectedBodyTypeId;
    _makeId = widget.selectedMakeId;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
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
                  onPressed: () => setState(() {
                    _bodyTypeId = null;
                    _makeId = null;
                  }),
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
                Text(
                  'العلامة التجارية',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.makes.map((make) {
                    final selected = _makeId == make.id;
                    return ChoiceChip(
                      label: Text(make.name),
                      selected: selected,
                      onSelected: (s) =>
                          setState(() => _makeId = s ? make.id : null),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Body Types
                Text(
                  'نوع الهيكل',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.bodyTypes.map((bt) {
                    final selected = _bodyTypeId == bt.id;
                    return ChoiceChip(
                      avatar: Text(bt.icon),
                      label: Text(bt.name),
                      selected: selected,
                      onSelected: (s) =>
                          setState(() => _bodyTypeId = s ? bt.id : null),
                    );
                  }).toList(),
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
                onPressed: () => widget.onApply(_bodyTypeId, _makeId),
                child: const Text('تطبيق'),
              ),
            ),
          ),
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
