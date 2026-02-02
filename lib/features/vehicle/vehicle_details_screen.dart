import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/common/data_state.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

import 'cubits/car_trim_cubit.dart';

class VehicleDetailScreen extends StatelessWidget {
  const VehicleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CarTrimCubit, DataState<CarTrim>>(
        builder: (context, state) => switch (state) {
          DataInitial() ||
          DataLoading() => const Center(child: CircularProgressIndicator()),
          DataError(:final error) => _ErrorBody(
            error: error,
            onRetry: () {
              // Need to get the ID somehow - usually passed via constructor
              // For now, pop back
              Navigator.pop(context);
            },
          ),
          DataLoaded(:final data) => _DetailBody(trim: data),
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.trim});

  final CarTrim trim;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _ImageGallery(
              images: trim.images,
              fallback: trim.displayImage,
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.p),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand & Year
                Row(
                  children: [
                    Text(
                      trim.brand.toUpperCase(),
                      style: tt.labelMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (trim.yearStart != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${trim.yearStart}',
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),

                // Model & Trim Name
                Text(
                  trim.modelAndTrim,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Price
                if (trim.priceRangeText case final price?) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: ThemeConstants.cardRadius,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sell_outlined, color: cs.onPrimaryContainer),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'السعر',
                              style: tt.labelSmall?.copyWith(
                                color: cs.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              price,
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Specs Section
                Text(
                  'المواصفات',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _SpecsGrid(specs: trim.specs),
                const SizedBox(height: 24),

                // Description
                if (trim.description case final desc? when desc.isNotEmpty) ...[
                  Text(
                    'الوصف',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          // TODO: Navigate to reviews
                        },
                        icon: const Icon(Icons.rate_review_outlined),
                        label: const Text('التجارب'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to questions
                        },
                        icon: const Icon(Icons.help_outline),
                        label: const Text('الأسئلة'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageGallery extends StatefulWidget {
  const _ImageGallery({required this.images, required this.fallback});

  final List<String> images;
  final String fallback;

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  int _current = 0;

  List<String> get _images =>
      widget.images.isNotEmpty ? widget.images : [widget.fallback];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_images.isEmpty || _images.first.isEmpty) {
      return Container(
        color: cs.surfaceContainerHighest,
        child: Center(
          child: Icon(Icons.directions_car, size: 64, color: cs.outline),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: _images.length,
          onPageChanged: (i) => setState(() => _current = i),
          itemBuilder: (_, i) => Image.network(
            _images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: cs.surfaceContainerHighest,
              child: Icon(Icons.broken_image, color: cs.outline),
            ),
          ),
        ),
        if (_images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _images.length,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _current
                        ? cs.primary
                        : cs.onSurface.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SpecsGrid extends StatelessWidget {
  const _SpecsGrid({required this.specs});

  final CarSpecs specs;

  @override
  Widget build(BuildContext context) {
    final items = <_SpecItem>[
      if (specs.rangeKm != null)
        _SpecItem('🔋', 'المدى', '${specs.rangeKm} كم'),
      if (specs.batteryKwh != null)
        _SpecItem('⚡', 'البطارية', '${specs.batteryKwh} kWh'),
      if (specs.fastChargeKw != null)
        _SpecItem('🔌', 'الشحن السريع', '${specs.fastChargeKw} kW'),
      if (specs.accelerationSec != null)
        _SpecItem('🚀', '0-100 كم/س', '${specs.accelerationSec} ث'),
      if (specs.topSpeedKmh != null)
        _SpecItem('💨', 'السرعة القصوى', '${specs.topSpeedKmh} كم/س'),
      if (specs.driveType != null)
        _SpecItem('🛞', 'نظام الدفع', specs.driveType!),
      if (specs.seats != null) _SpecItem('🪑', 'المقاعد', '${specs.seats}'),
    ];

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: ThemeConstants.cardRadius,
        ),
        child: Center(
          child: Text(
            'لا توجد مواصفات متاحة',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _SpecTile(item: items[i]),
    );
  }
}

class _SpecItem {
  final String icon;
  final String label;
  final String value;

  const _SpecItem(this.icon, this.label, this.value);
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({required this.item});

  final _SpecItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(item.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                Text(
                  item.value,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text('حدث خطأ', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.arrow_back),
            label: const Text('العودة'),
          ),
        ],
      ),
    );
  }
}
