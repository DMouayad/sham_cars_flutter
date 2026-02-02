// lib/features/vehicle/screens/vehicle_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/common/data_state.dart';
import 'package:sham_cars/features/theme/constants.dart';

import 'cubits/car_trim_cubit.dart';
import 'models.dart';
import 'widgets/spec_list.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key, required this.trimSummary});

  final CarTrimSummary trimSummary; // Optional preview data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CarTrimCubit, DataState<CarTrim>>(
        builder: (context, state) => switch (state) {
          DataInitial() || DataLoading() => _LoadingBody(summary: trimSummary),
          DataError(:final error) => _ErrorBody(
            summary: trimSummary,
            onRetry: () => context.read<CarTrimCubit>().load(trimSummary.id),
          ),
          DataLoaded(:final data) => _DetailBody(trim: data),
        },
      ),
    );
  }
}

/// Shows preview from summary while loading full details
class _LoadingBody extends StatelessWidget {
  const _LoadingBody({this.summary});

  final CarTrimSummary? summary;

  @override
  Widget build(BuildContext context) {
    if (summary == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final s = summary!;

    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _PreviewImage(imageUrl: s.imageUrl),
          ),
        ),

        // Preview Content
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
                      s.makeName.toUpperCase(),
                      style: tt.labelMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (s.yearDisplay case final year?) ...[
                      const SizedBox(width: 8),
                      _Badge(text: year),
                    ],
                    if (s.bodyType.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      _Badge(text: s.bodyType, isPrimary: true),
                    ],
                  ],
                ),
                const SizedBox(height: 8),

                // Model & Trim Name
                Text(
                  s.displayName,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Price (if available)
                if (s.priceDisplay case final price?) ...[
                  _PriceCard(price: price),
                  const SizedBox(height: 24),
                ],

                // Key Specs Preview
                _KeySpecsRowPreview(summary: s),
                const SizedBox(height: 24),

                // Loading indicator for more content
                _LoadingMoreSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _ImagePlaceholder(),
      );
    }
    return _ImagePlaceholder();
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.directions_car, size: 64, color: cs.outline),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, this.isPrimary = false});
  final String text;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isPrimary ? cs.secondaryContainer : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isPrimary ? cs.onSecondaryContainer : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.price});
  final String price;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
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
                style: tt.labelSmall?.copyWith(color: cs.onPrimaryContainer),
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
    );
  }
}

class _KeySpecsRowPreview extends StatelessWidget {
  const _KeySpecsRowPreview({required this.summary});
  final CarTrimSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = <_KeySpec>[
      if (summary.range.isNotEmpty)
        _KeySpec(Icons.route, 'المدى', summary.range.display, Colors.green),
      if (summary.batteryCapacity.isNotEmpty)
        _KeySpec(
          Icons.battery_charging_full,
          'البطارية',
          summary.batteryCapacity.display,
          Colors.blue,
        ),
      if (summary.acceleration.isNotEmpty)
        _KeySpec(
          Icons.speed,
          '0-100',
          summary.acceleration.display,
          Colors.orange,
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Row(
      children: items
          .map((item) => Expanded(child: _KeySpecCard(spec: item)))
          .expand((w) => [w, const SizedBox(width: 12)])
          .take(items.length * 2 - 1)
          .toList(),
    );
  }
}

class _KeySpec {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _KeySpec(this.icon, this.label, this.value, this.color);
}

class _KeySpecCard extends StatelessWidget {
  const _KeySpecCard({required this.spec});
  final _KeySpec spec;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: spec.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: spec.color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(spec.icon, size: 24, color: spec.color),
          const SizedBox(height: 8),
          Text(
            spec.value,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          Text(
            spec.label,
            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _LoadingMoreSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: ThemeConstants.cardRadius,
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(height: 12),
          Text(
            'جاري تحميل المزيد...',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Full detail body (after loading completes)
class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.trim});

  final CarTrim trim;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        // App Bar with Image Gallery
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _ImageGallery(images: trim.images),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.p),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand & Year & Body Type
                Row(
                  children: [
                    Text(
                      trim.makeName.toUpperCase(),
                      style: tt.labelMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (trim.yearDisplay case final year?) ...[
                      const SizedBox(width: 8),
                      _Badge(text: year),
                    ],
                    if (trim.bodyType.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      _Badge(text: trim.bodyType, isPrimary: true),
                    ],
                  ],
                ),
                const SizedBox(height: 8),

                // Model & Trim Name
                Text(
                  trim.displayName,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Price Card
                if (trim.priceRangeText case final price?) ...[
                  _PriceCard(price: price),
                  const SizedBox(height: 24),
                ],

                // Key Specs
                _KeySpecsRow(trim: trim),
                const SizedBox(height: 24),

                // All Specs (expandable)
                Text(
                  'المواصفات',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ExpandableSpecsList(specs: trim.specs),
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
                        onPressed: () {},
                        icon: const Icon(Icons.rate_review_outlined),
                        label: const Text('التجارب'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
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

class _KeySpecsRow extends StatelessWidget {
  const _KeySpecsRow({required this.trim});
  final CarTrim trim;

  @override
  Widget build(BuildContext context) {
    final items = <_KeySpec>[
      if (trim.range.isNotEmpty)
        _KeySpec(Icons.route, 'المدى', trim.range.display, Colors.green),
      if (trim.batteryCapacity.isNotEmpty)
        _KeySpec(
          Icons.battery_charging_full,
          'البطارية',
          trim.batteryCapacity.display,
          Colors.blue,
        ),
      if (trim.acceleration.isNotEmpty)
        _KeySpec(
          Icons.speed,
          '0-100',
          trim.acceleration.display,
          Colors.orange,
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Row(
      children: items
          .map((item) => Expanded(child: _KeySpecCard(spec: item)))
          .expand((w) => [w, const SizedBox(width: 12)])
          .take(items.length * 2 - 1)
          .toList(),
    );
  }
}

class _ImageGallery extends StatefulWidget {
  const _ImageGallery({required this.images});
  final List<String> images;

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (widget.images.isEmpty) {
      return _ImagePlaceholder();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (i) => setState(() => _current = i),
          itemBuilder: (_, i) => Image.network(
            widget.images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: cs.surfaceContainerHighest,
              child: Icon(Icons.broken_image, color: cs.outline),
            ),
          ),
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == _current ? 16 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
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

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({this.summary, required this.onRetry});

  final CarTrimSummary? summary;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // If we have summary, show it with error banner
    if (summary != null) {
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: '${summary?.id}-image',

                child: _PreviewImage(imageUrl: summary!.imageUrl),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.p),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Error banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.cloud_off, color: cs.onErrorContainer),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'تعذر تحميل التفاصيل الكاملة',
                            style: TextStyle(color: cs.onErrorContainer),
                          ),
                        ),
                        TextButton(
                          onPressed: onRetry,
                          child: const Text('إعادة'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Basic info from summary
                  Text(
                    summary!.makeName.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    summary!.displayName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // No summary, show full error screen
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: cs.error),
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
