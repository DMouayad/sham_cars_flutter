import 'package:flutter/material.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/reviews/widgets/review_card.dart';
import 'package:sham_cars/features/theme/constants.dart';

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({
    super.key,
    required this.reviews,
    required this.onOpenVehicle,
    required this.onRefresh,
  });

  final List<HomeReview> reviews;
  final void Function(int id) onOpenVehicle;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return _EmptyState(
        icon: Icons.rate_review_outlined,
        title: 'لا توجد تجارب',
        subtitle: 'شارك تجربتك مع الآخرين!',
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(ThemeConstants.p),
        itemCount: reviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final review = reviews[i];
          return ReviewCard(
            review: review,
            onOpenVehicle: review.vehicle != null
                ? () => onOpenVehicle(review.vehicle!.id)
                : null,
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: cs.outline),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.outline),
          ),
        ],
      ),
    );
  }
}
