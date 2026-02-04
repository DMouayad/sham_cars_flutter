import 'package:flutter/material.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/theme/constants.dart';

class CommunityReviewCard extends StatelessWidget {
  const CommunityReviewCard({super.key, required this.review, this.onTap});

  final Review review;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: review.trimId != null && onTap != null
          ? () => onTap!(review.trimId!)
          : null,
      borderRadius: ThemeConstants.cardRadius,
      child: Ink(
        padding: const EdgeInsets.all(ThemeConstants.pSm),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: ThemeConstants.cardRadius,
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type badge + Rating
            Row(
              children: [
                _TypeBadge(
                  icon: Icons.rate_review_outlined,
                  text: 'تجربة',
                  color: cs.secondaryContainer,
                  onColor: cs.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                _RatingStars(rating: review.rating),
                const Spacer(),
                Text(
                  _formatDate(review.createdAt),
                  style: tt.labelSmall?.copyWith(color: cs.outline),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Trim info (if available)
            if (review.trimName != null) ...[
              _TrimRow(review: review),
              const SizedBox(height: 12),
            ],

            // Review content
            if (review.title?.isNotEmpty ?? false) ...[
              Text(
                review.title!,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            Text(
              review.body,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Footer
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    review.userName.isNotEmpty ? review.userName[0] : '؟',
                    style: tt.labelSmall?.copyWith(
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    review.userName,
                    style: tt.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (review.cityCode case final city?)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _cityLabel(city),
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return 'الآن';
      return 'منذ ${diff.inHours} س';
    }
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${dt.day}/${dt.month}';
  }

  String _cityLabel(String code) => switch (code) {
    'damascus' => 'دمشق',
    'aleppo' => 'حلب',
    'homs' => 'حمص',
    'hama' => 'حماة',
    'latakia' => 'اللاذقية',
    'tartus' => 'طرطوس',
    _ => code,
  };
}

class _TrimRow extends StatelessWidget {
  const _TrimRow({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 48,
            height: 48,
            child:
                review.trimImageUrl != null && review.trimImageUrl!.isNotEmpty
                ? Image.network(
                    review.trimImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                  )
                : _ImagePlaceholder(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.makeName?.toUpperCase() ?? '',
                style: tt.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                review.trimDisplayName ?? '',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (review.trimRange?.isNotEmpty ?? false)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.route, size: 12, color: Colors.green),
                const SizedBox(width: 4),
                Text(review.trimRange!, style: tt.labelSmall),
              ],
            ),
          ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surfaceContainerHighest,
      child: Icon(Icons.directions_car, size: 20, color: cs.outline),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({
    required this.icon,
    required this.text,
    required this.color,
    required this.onColor,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: onColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: onColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 14,
          color: Colors.amber,
        );
      }),
    );
  }
}
