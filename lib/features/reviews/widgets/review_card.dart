import 'package:flutter/material.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/widgets/pill_chip.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review, this.onOpenVehicle});

  final HomeReview review;
  final VoidCallback? onOpenVehicle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final v = review.vehicle;

    return InkWell(
      onTap: onOpenVehicle,
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
            // Vehicle header (if available)
            if (v != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: ThemeConstants.thumbRadius,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: v.imageUrl.isNotEmpty
                          ? Image.network(
                              v.imageUrl,
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
                          '${v.brandName}${v.year != null ? ' • ${v.year}' : ''}',
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          v.name,
                          style: tt.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _RatingAndCity(review: review),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ] else ...[
              // Just rating if no vehicle
              _RatingAndCity(review: review),
              const SizedBox(height: 12),
            ],

            // Review content
            if (review.title.isNotEmpty) ...[
              Text(review.title, style: tt.titleSmall),
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
                Expanded(
                  child: Text(
                    '${review.userName} • ${_formatDate(review.createdAt)}',
                    style: tt.labelSmall?.copyWith(color: cs.outline),
                  ),
                ),
                if (onOpenVehicle != null)
                  TextButton(
                    onPressed: onOpenVehicle,
                    child: const Text('عرض'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) return 'الآن';
      return 'منذ ${diff.inHours} ساعة';
    }
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _RatingAndCity extends StatelessWidget {
  const _RatingAndCity({required this.review});

  final HomeReview review;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        PillChip(
          text: '${review.rating}/5',
          icon: const Icon(Icons.star, size: 14, color: Colors.amber),
        ),
        if (review.cityCode case final code?) PillChip(text: _cityLabel(code)),
      ],
    );
  }

  String _cityLabel(String code) => switch (code) {
    'damascus' => 'دمشق',
    'aleppo' => 'حلب',
    'homs' => 'حمص',
    'latakia' => 'اللاذقية',
    'tartus' => 'طرطوس',
    'hama' => 'حماة',
    _ => code,
  };
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
