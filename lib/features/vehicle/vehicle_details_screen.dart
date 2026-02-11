import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sham_cars/features/common/data_state.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/home/widgets/custom_drawer.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/user_profile/repositories/user_activity_repository.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';

import 'cubits/car_trim_cubit.dart';
import 'cubits/trim_community_preview_cubit.dart';
import 'cubits/similar_trims_cubit.dart';
import 'models.dart';
import 'repositories/car_data_repository.dart';
import 'trim_community_screen.dart';
import 'widgets/community_preview.dart';
import 'widgets/specs.dart';
import 'widgets/similar_trims_section.dart';

/// View-model to keep UI simple (summary and full trim share same UI)
class _VehicleVm {
  final int trimId;
  final String makeName;
  final String displayName; // pinned title
  final String? yearDisplay;
  final String bodyType;

  final List<String> images;

  final String? priceText;

  final String rangeText;
  final String batteryText;
  final String accelText;

  final Map<String, String> specs; // full specs
  final String? description;

  const _VehicleVm({
    required this.trimId,
    required this.makeName,
    required this.displayName,
    required this.images,
    this.yearDisplay,
    this.bodyType = '',
    this.priceText,
    this.rangeText = '',
    this.batteryText = '',
    this.accelText = '',
    this.specs = const {},
    this.description,
  });

  factory _VehicleVm.fromSummary(CarTrimSummary s) {
    return _VehicleVm(
      trimId: s.id,
      makeName: s.makeName,
      displayName: s.displayName,
      yearDisplay: s.yearDisplay,
      bodyType: s.bodyType,
      images: [if ((s.imageUrl ?? '').isNotEmpty) s.imageUrl!],
      priceText: s.priceDisplay,
      rangeText: s.range.isNotEmpty ? s.range.display : '',
      batteryText: s.batteryCapacity.isNotEmpty
          ? s.batteryCapacity.display
          : '',
      accelText: s.acceleration.isNotEmpty ? s.acceleration.display : '',
      // summary has no full specs
      specs: const {},
      description: null,
    );
  }

  factory _VehicleVm.fromTrim(CarTrim t) {
    return _VehicleVm(
      trimId: t.id,
      makeName: t.makeName,
      displayName: t.displayName,
      yearDisplay: t.yearDisplay,
      bodyType: t.bodyType,
      images: t.images,
      priceText: t.priceRangeText,
      rangeText: t.range.isNotEmpty ? t.range.display : '',
      batteryText: t.batteryCapacity.isNotEmpty
          ? t.batteryCapacity.display
          : '',
      accelText: t.acceleration.isNotEmpty ? t.acceleration.display : '',
      specs: t.specs,
      description: (t.description?.isNotEmpty ?? false) ? t.description : null,
    );
  }
}

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({
    super.key,
    required this.trimId,
    this.trimSummary,
  });
  final int trimId;
  final CarTrimSummary? trimSummary;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TrimCommunityPreviewCubit(
            context.read<CommunityRepository>(),
            context.read<UserActivityRepository>(),
          )..load(trimId: trimId),
        ),
        BlocProvider(
          create: (_) =>
              SimilarTrimsCubit(context.read<CarDataRepository>())
                ..load(trimId),
        ),
      ],

      child: Scaffold(
        endDrawer: const CustomDrawer(),
        body: SafeArea(
          top: false,
          child: BlocBuilder<CarTrimCubit, DataState<CarTrim>>(
            builder: (context, state) {
              // Build a single VM for both states (summary while loading, trim when loaded)
              final vm = switch (state) {
                DataLoaded(:final data) => _VehicleVm.fromTrim(data),
                _ =>
                  trimSummary != null
                      ? _VehicleVm.fromSummary(trimSummary!)
                      : null,
              };
              if (vm == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return switch (state) {
                DataInitial() || DataLoading() => _VehicleDetailsView(
                  vm: vm,
                  loadingMore: true,
                  onRetry: null,
                ),
                DataError() => _VehicleDetailsView(
                  vm: vm,
                  loadingMore: false,
                  onRetry: () => context.read<CarTrimCubit>().load(trimId),
                ),
                DataLoaded(:final data) => _VehicleDetailsView(
                  vm: _VehicleVm.fromTrim(data),
                  loadingMore: false,
                  onRetry: null,
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _VehicleDetailsView extends StatelessWidget {
  const _VehicleDetailsView({
    required this.vm,
    required this.loadingMore,
    required this.onRetry,
  });

  final _VehicleVm vm;
  final bool loadingMore;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          stretch: true,
          backgroundColor: cs.surface.withOpacity(0.88),
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text(
            vm.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),

          flexibleSpace: FlexibleSpaceBar(
            background: _GalleryHeader(
              images: vm.images,
              makeName: vm.makeName,
              yearDisplay: vm.yearDisplay,
              bodyType: vm.bodyType,
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(ThemeConstants.p),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (onRetry != null) _ErrorBanner(onRetry: onRetry!),
              const SizedBox(height: 12),

              _KeySpecsRow(
                rangeText: vm.rangeText,
                batteryText: vm.batteryText,
                accelText: vm.accelText,
                priceText: vm.priceText,
              ),
              const SizedBox(height: 20),

              BlocBuilder<
                TrimCommunityPreviewCubit,
                DataState<TrimCommunityPreview>
              >(
                builder: (context, st) {
                  return switch (st) {
                    DataLoading() ||
                    DataInitial() => const _LoadingMoreSection(),
                    DataError() =>
                      const SizedBox.shrink(), // or show a small banner
                    DataLoaded(:final data) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (vm.specs.isNotEmpty) ...[
                          _SectionTitle(
                            title: context.l10n.vehicleDetailsSpecsTitle,
                          ),
                          const SizedBox(height: 10),
                          GroupedSpecs(specs: vm.specs),
                          const SizedBox(height: 20),
                        ],
                        ReviewsPreview(
                          items: data.reviews,
                          userReview: data.myReview,
                          onViewAll: () {
                            VehicleCommunityReviewsRoute(
                              vm.trimId,
                              title: vm.displayName,
                            ).push(context);
                          },
                          onAdd: () async {
                            final didPost = await TrimCommunityScreen.showSheet(
                              context,
                              trimId: vm.trimId,
                              trimTitle: vm.displayName,
                              isQuestion: false,
                            );

                            if (didPost == true && context.mounted) {
                              context.read<TrimCommunityPreviewCubit>().load(
                                trimId: vm.trimId,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        QuestionsPreview(
                          myQuestions: data.myQuestions,
                          items: data.questions,
                          onAddNew: () async {
                            final didPost = await TrimCommunityScreen.showSheet(
                              context,
                              trimTitle: vm.displayName,
                              trimId: vm.trimId,
                              isQuestion: true,
                            );

                            if (didPost == true && context.mounted) {
                              context.read<TrimCommunityPreviewCubit>().load(
                                trimId: vm.trimId,
                              );
                            }
                          },
                          onViewAll: () {
                            VehicleCommunityQuestionsRoute(
                              vm.trimId,
                              title: vm.displayName,
                            ).push(context);
                          },
                        ),
                      ],
                    ),
                  };
                },
              ),

              const SizedBox(height: 20),

              if (vm.description != null) ...[
                _SectionTitle(
                  title: context.l10n.vehicleDetailsDescriptionTitle,
                ),
                const SizedBox(height: 10),
                Text(
                  vm.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const SimilarTrimsSection(),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ],
    );
  }
}

class _GalleryHeader extends StatefulWidget {
  const _GalleryHeader({
    required this.images,
    required this.makeName,
    required this.yearDisplay,
    required this.bodyType,
  });

  final List<String> images;
  final String makeName;
  final String? yearDisplay;
  final String bodyType;
  @override
  State<_GalleryHeader> createState() => _GalleryHeaderState();
}

class _GalleryHeaderState extends State<_GalleryHeader> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final images = widget.images.where((e) => e.isNotEmpty).toList();
    if (images.isEmpty) return const _ImagePlaceholder();

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: (i) => setState(() => _current = i),
          itemBuilder: (_, i) => Image.network(
            images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: cs.surfaceContainerHighest,
              child: Icon(Icons.broken_image, color: cs.outline),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.35, 1.0],
                colors: [
                  // “white at top” but theme-aware (light mode = white, dark mode = dark surface)
                  Theme.of(context).colorScheme.surface.withOpacity(0.70),
                  Colors.transparent,
                  // black at bottom
                  Colors.black.withOpacity(0.45),
                ],
              ),
            ),
          ),
        ),

        // Pills inside header stack (top area)
        PositionedDirectional(
          bottom: MediaQuery.paddingOf(context).bottom + 12,
          start: 16,
          end: 16,
          child: _HeaderPills(
            makeName: widget.makeName,
            yearDisplay: widget.yearDisplay,
            bodyType: widget.bodyType,
          ),
        ),

        if (images.length > 1)
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == _current ? 16 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: i == _current
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderPills extends StatelessWidget {
  const _HeaderPills({
    required this.makeName,
    required this.yearDisplay,
    required this.bodyType,
  });

  final String makeName;
  final String? yearDisplay;
  final String bodyType;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _GlassPill(text: makeName.toUpperCase()),
        if (yearDisplay != null) _GlassPill(text: yearDisplay!),
        if (bodyType.isNotEmpty) _GlassPill(text: bodyType),
      ],
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.30),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

// class _RealWorldRangeCard extends StatelessWidget {
//   const _RealWorldRangeCard({
//     required this.cityLabel,
//     required this.seasonLabel,
//     required this.valueText,
//     required this.onAdd,
//   });

//   final String cityLabel;
//   final String seasonLabel;
//   final String valueText;
//   final VoidCallback onAdd;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cs.surfaceContainerHighest,
//         borderRadius: ThemeConstants.cardRadius,
//         border: Border.all(color: cs.outlineVariant),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'المدى الحقيقي (80% → 20%)',
//             style: Theme.of(
//               context,
//             ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             '$cityLabel • $seasonLabel',
//             style: Theme.of(
//               context,
//             ).textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Text(
//                 valueText,
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 'كم',
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleMedium?.copyWith(color: cs.onSurfaceVariant),
//               ),
//               const Spacer(),
//               FilledButton.icon(
//                 onPressed: onAdd,
//                 icon: const Icon(Icons.add),
//                 label: const Text('أضف بياناتك'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off, color: cs.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'تعذر تحميل التفاصيل الكاملة',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onErrorContainer),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
        ],
      ),
    );
  }
}

class _KeySpecsRow extends StatelessWidget {
  const _KeySpecsRow({
    required this.rangeText,
    required this.batteryText,
    required this.accelText,
    this.priceText,
  });

  final String rangeText;
  final String batteryText;
  final String accelText;
  final String? priceText;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final specs = <_KeySpec>[
      if (rangeText.isNotEmpty)
        _KeySpec(
          Icons.route,
          context.l10n.vehicleDetailsRange,
          rangeText,
          Colors.green,
        ),
      if (batteryText.isNotEmpty)
        _KeySpec(
          Icons.battery_charging_full,
          context.l10n.vehicleDetailsBattery,
          batteryText,
          Colors.blue,
        ),
      if (accelText.isNotEmpty)
        _KeySpec(Icons.speed, '0-100', accelText, Colors.orange),
    ];

    if (specs.isEmpty && (priceText == null || priceText!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: ThemeConstants.cardRadius,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          if (specs.isNotEmpty)
            Row(
              children: specs
                  .map((s) => Expanded(child: _KeySpecCard(spec: s)))
                  .expand((w) => [w, const SizedBox(width: 12)])
                  .take(specs.length * 2 - 1)
                  .toList(),
            ),

          if (priceText != null && priceText!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(color: cs.outlineVariant, height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.sell_outlined, size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  context.l10n.vehicleDetailsPrice,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const Spacer(),
                Text(
                  priceText!,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        ],
      ),
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
        color: spec.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: spec.color.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Icon(spec.icon, size: 22, color: spec.color),
          const SizedBox(height: 8),
          Text(
            spec.value,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800),
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
  const _LoadingMoreSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 10),
          Text(
            context.l10n.commonLoadingMore,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

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
