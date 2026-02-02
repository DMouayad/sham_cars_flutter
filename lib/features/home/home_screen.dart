import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sham_cars/features/common/data_state.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/reviews/widgets/review_card.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/widgets/compact_vehicle_card.dart';

import 'home_cubit.dart';
import 'models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenModel,
    required this.onOpenQuestion,
    required this.onViewAllVehicles,
    required this.onViewAllQuestions,
  });

  final void Function(int modelId) onOpenModel;
  final void Function(int questionId) onOpenQuestion;
  final VoidCallback onViewAllVehicles;
  final VoidCallback onViewAllQuestions;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, DataState<HomeData>>(
      builder: (context, state) => switch (state) {
        DataInitial() ||
        DataLoading() => const Center(child: CircularProgressIndicator()),
        DataError(:final error) => _ErrorView(
          error: error,
          onRetry: () => context.read<HomeCubit>().load(),
        ),
        DataLoaded(:final data) => _HomeContent(
          data: data,
          onOpenModel: onOpenModel,
          onOpenQuestion: onOpenQuestion,
          onViewAllVehicles: onViewAllVehicles,
          onViewAllQuestions: onViewAllQuestions,
          onRefresh: () => context.read<HomeCubit>().refresh(),
        ),
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.data,
    required this.onOpenModel,
    required this.onOpenQuestion,
    required this.onViewAllVehicles,
    required this.onViewAllQuestions,
    required this.onRefresh,
  });

  final HomeData data;
  final void Function(int) onOpenModel;
  final void Function(int) onOpenQuestion;
  final VoidCallback onViewAllVehicles;
  final VoidCallback onViewAllQuestions;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final enrichedModels = data.enrichedModels;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(ThemeConstants.p),
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: 'ابحث عن سيارة أو علامة...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.rCard),
              ),
            ),
          ),

          // Discover Vehicles
          if (enrichedModels.isNotEmpty) ...[
            const SizedBox(height: 18),
            _SectionHeader(title: 'اكتشف السيارات', onTap: onViewAllVehicles),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: enrichedModels.length.clamp(0, 10),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final model = enrichedModels[i];
                  return SizedBox(
                    width: 280,
                    child: CompactModelCard(
                      model: model,
                      onTap: () => onOpenModel(model.id),
                    ),
                  );
                },
              ),
            ),
          ],

          // Latest Questions
          if (data.latestQuestions.isNotEmpty) ...[
            const SizedBox(height: 22),
            _SectionHeader(title: 'أحدث الأسئلة', onTap: onViewAllQuestions),
            const SizedBox(height: 10),
            ...data.latestQuestions
                .take(3)
                .map(
                  (q) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: QuestionCard(
                      question: q,
                      onTap: () => onOpenQuestion(q.id),
                    ),
                  ),
                ),
          ],

          // Latest Reviews
          if (data.latestReviews.isNotEmpty) ...[
            const SizedBox(height: 22),
            _SectionHeader(title: 'أحدث التجارب', onTap: onViewAllVehicles),
            const SizedBox(height: 10),
            ...data.latestReviews
                .take(3)
                .map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ReviewCard(
                      review: r,
                      onOpenVehicle: r.vehicle != null
                          ? () => onOpenModel(r.vehicle!.id)
                          : null,
                    ),
                  ),
                ),
          ] else ...[
            // Placeholder if no reviews
            const SizedBox(height: 22),
            _SectionHeader(title: 'أحدث التجارب', onTap: onViewAllVehicles),
            const SizedBox(height: 10),
            _ReviewsPlaceholder(),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        TextButton(onPressed: onTap, child: const Text('عرض الكل')),
      ],
    );
  }
}

class _ReviewsPlaceholder extends StatelessWidget {
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
          Icon(Icons.rate_review_outlined, size: 40, color: cs.outline),
          const SizedBox(height: 12),
          Text(
            'لا توجد تجارب بعد',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            'كن أول من يشارك تجربته!',
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
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
      ),
    );
  }
}
