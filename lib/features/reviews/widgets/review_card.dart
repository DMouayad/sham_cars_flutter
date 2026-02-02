import 'package:flutter/material.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review, this.onOpenTrim});

  final HomeReview review;
  final void Function(CarTrimSummary trim)? onOpenTrim;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final trim = review.trimSummary;

    return InkWell(
      onTap: trim != null && onOpenTrim != null
          ? () => onOpenTrim!(trim)
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
            // Trim header (if available)
            if (trim != null && trim.hasBasicInfo) ...[
              _TrimHeader(trim: trim),
              const SizedBox(height: 12),
            ],

            // Rating row (if no trim header, show rating at top)
            if (trim == null || !trim.hasBasicInfo)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RatingAndCity(review: review),
              ),

            // Review content
            if (review.title.isNotEmpty) ...[
              Text(
                review.title,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            Text(
              review.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),

            const SizedBox(height: 12),

            // Footer
            Row(
              children: [
                _UserAvatar(userName: review.userName),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: tt.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatDate(review.createdAt),
                        style: tt.labelSmall?.copyWith(color: cs.outline),
                      ),
                    ],
                  ),
                ),
                if (trim != null && onOpenTrim != null)
                  TextButton(
                    onPressed: () => onOpenTrim!(trim),
                    child: const Text('عرض السيارة'),
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
      return 'منذ ${diff.inHours} ساعة';
    }
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _TrimHeader extends StatelessWidget {
  const _TrimHeader({required this.trim});
  final CarTrimSummary trim;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 56,
            height: 56,
            child: trim.imageUrl != null && trim.imageUrl!.isNotEmpty
                ? Image.network(
                    trim.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                  )
                : _ImagePlaceholder(),
          ),
        ),
        const SizedBox(width: 12),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand & Year
              Row(
                children: [
                  Text(
                    trim.makeName.toUpperCase(),
                    style: tt.labelSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (trim.yearDisplay case final year?) ...[
                    Text(
                      ' • $year',
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),

              // Name
              Text(
                trim.displayName,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Rating & specs chips
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _RatingChip(rating: 5), // From parent review
                  if (trim.range.isNotEmpty)
                    _SpecChip(
                      icon: Icons.route,
                      text: trim.range.display,
                      color: Colors.green,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Update _TrimHeader to receive rating:
class _TrimHeaderWithRating extends StatelessWidget {
  const _TrimHeaderWithRating({required this.trim, required this.rating});

  final CarTrimSummary trim;
  final int rating;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 56,
            height: 56,
            child: trim.imageUrl != null && trim.imageUrl!.isNotEmpty
                ? Image.network(
                    trim.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                  )
                : _ImagePlaceholder(),
          ),
        ),
        const SizedBox(width: 12),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand & Year
              Row(
                children: [
                  Text(
                    trim.makeName.toUpperCase(),
                    style: tt.labelSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (trim.yearDisplay case final year?) ...[
                    Text(
                      ' • $year',
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),

              // Name
              Text(
                trim.displayName,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Rating & specs chips
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _RatingChip(rating: rating),
                  if (trim.range.isNotEmpty)
                    _SpecChip(
                      icon: Icons.route,
                      text: trim.range.display,
                      color: Colors.green,
                    ),
                ],
              ),
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
      child: Icon(Icons.directions_car, size: 24, color: cs.outline),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.rating});
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
          const SizedBox(width: 2),
          Text(
            '$rating/5',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingAndCity extends StatelessWidget {
  const _RatingAndCity({required this.review});
  final HomeReview review;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _RatingChip(rating: review.rating),
        if (review.cityCode case final code?)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _cityLabel(code),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
      ],
    );
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

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: 16,
      backgroundColor: cs.primaryContainer,
      child: Text(
        userName.isNotEmpty ? userName[0].toUpperCase() : '؟',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: cs.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
