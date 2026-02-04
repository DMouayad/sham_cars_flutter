import 'package:flutter/material.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/date_time_text.dart';

class CommunityReviewCard extends StatelessWidget {
  const CommunityReviewCard({super.key, required this.review, this.onTap});

  final Review review;
  final void Function(int trimId)? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
          padding: const EdgeInsets.all(ThemeConstants.pSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: "تجربة" + rating + time
              Row(
                children: [
                  _Pill(
                    text: 'تجربة',
                    icon: Icons.rate_review_outlined,
                    background: cs.secondaryContainer,
                    foreground: cs.onSecondaryContainer,
                  ),
                  const SizedBox(width: 8),
                  _Pill(
                    text: '${review.rating}/5',
                    icon: Icons.star_rounded,
                    iconColor: Colors.amber,
                    background: cs.primaryContainer,
                    foreground: cs.onPrimaryContainer,
                  ),
                  const Spacer(),
                  Text(
                    DateTimeText.relativeOrShort(context, review.createdAt),
                    style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Vehicle (headline)
              Text(
                review.trimDisplayName ?? (review.trimName ?? '—'),
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Optional title
              if (review.title?.trim().isNotEmpty ?? false) ...[
                Text(
                  review.title!.trim(),
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
              ],

              // Comment
              Text(
                review.comment,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.55,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer: user + city
              Row(
                children: [
                  _AvatarLetter(name: review.userName),
                  const SizedBox(width: 8),
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
                    _Pill(
                      text: _cityLabel(city),
                      icon: Icons.location_city,
                      background: cs.surfaceContainerHighest,
                      foreground: cs.onSurfaceVariant,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
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

class _AvatarLetter extends StatelessWidget {
  const _AvatarLetter({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final letter = name.trim().isNotEmpty
        ? name.trim().characters.first.toUpperCase()
        : '؟';

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Text(letter, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.icon,
    required this.background,
    required this.foreground,
    this.iconColor,
  });

  final String text;
  final IconData icon;
  final Color background;
  final Color foreground;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor ?? foreground),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
