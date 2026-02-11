import 'package:flutter/material.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/city_text.dart';
import 'package:sham_cars/utils/date_time_text.dart';

class CommunityReviewCard extends StatelessWidget {
  const CommunityReviewCard({super.key, required this.review, this.onTap});

  final Review review;
  final void Function(int trimId)? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final accentColor = cs.primary;

    final canOpen = review.trimId != null && onTap != null;

    return Material(
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.cardRadius,
        side: BorderSide(color: cs.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: canOpen ? () => onTap!(review.trimId!) : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER: Icon + Car Name + Rating + Date ---
              Row(
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 16,
                    color: accentColor,
                  ),

                  const SizedBox(width: 8),

                  // Car Name (takes available space)
                  Expanded(
                    child: Text(
                      review.trimDisplayName ?? (review.trimName ?? '—'),
                      style: tt.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Rating (Fixed width)
                  _HeaderRatingBadge(rating: review.rating.toDouble()),

                  const SizedBox(width: 8),

                  // Date (Fixed width)
                  Text(
                    DateTimeText.relativeOrShort(context, review.createdAt),
                    style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // --- BODY: Title (Optional) + Comment ---
              if (review.title?.trim().isNotEmpty ?? false) ...[
                Text(
                  review.title!.trim(),
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
              ],

              Text(
                review.comment,
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 14),

              // --- FOOTER: User + City ---
              Row(
                children: [
                  _AvatarLetter(name: review.userName),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      review.userName,
                      style: tt.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (review.cityCode case final city?)
                    _InfoChip(
                      icon: Icons.location_on_outlined,
                      text: CityText.label(context, city),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderRatingBadge extends StatelessWidget {
  const _HeaderRatingBadge({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rating.toString(),
            maxLines: 1,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.orange[900],
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({this.icon, required this.text});
  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: cs.onSurfaceVariant),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
