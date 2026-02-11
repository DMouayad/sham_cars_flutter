import 'package:flutter/material.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/date_time_text.dart';

enum ReviewCardVariant { normal, mine }

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
    this.onTap,
    this.compact = false,
    this.variant = ReviewCardVariant.normal,
    this.headerLabel,
  });

  final Review review;
  final VoidCallback? onTap;
  final bool compact;

  final ReviewCardVariant variant;
  final String? headerLabel; // e.g. "Your review"

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final isMine = variant == ReviewCardVariant.mine;

    final content = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isMine
            ? cs.primaryContainer.withValues(alpha: 0.35)
            : cs.surface,
        borderRadius: ThemeConstants.cardRadius,
        border: Border.all(
          color: isMine
              ? cs.primary.withValues(alpha: 0.45)
              : cs.outlineVariant,
          width: isMine ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // optional label row
          if (headerLabel != null) ...[
            Row(
              children: [
                Icon(
                  Icons.person_rounded,
                  size: 16,
                  color: isMine ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  headerLabel!,
                  style: tt.labelMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isMine ? cs.primary : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          Row(
            children: [
              _AvatarLetter(name: review.userName),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateTimeText.relativeOrShort(context, review.createdAt),
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _RatingPill(rating: review.rating),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            review.body,
            maxLines: compact ? 3 : 8,
            overflow: TextOverflow.ellipsis,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: ThemeConstants.cardRadius,
      child: content,
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});
  final int rating;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final clamped = rating.clamp(1, 5);

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            '$clamped/5',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarLetter extends StatelessWidget {
  const _AvatarLetter({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final letter = name.trim().isNotEmpty
        ? name.trim().characters.first.toUpperCase()
        : '?';

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}
