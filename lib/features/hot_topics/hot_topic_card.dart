import 'package:flutter/material.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/utils.dart';

class HotTopicCard extends StatelessWidget {
  const HotTopicCard({
    super.key,
    required this.topic,
    required this.rank,
    this.onTap,
  });

  final HotTopic topic;
  final int rank;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Material(
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.cardRadius,
        side: BorderSide(color: cs.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _RankBadge(rank: rank),
                  const Spacer(),
                  // if (topic.isHot)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  //     decoration: BoxDecoration(
                  //       color: cs.errorContainer,
                  //       borderRadius: BorderRadius.circular(999),
                  //     ),
                  //     child: Text(
                  //       l10n.hotLabel, // add ARB
                  //       style: TextStyle(
                  //         color: cs.onErrorContainer,
                  //         fontWeight: FontWeight.w800,
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //   ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, color: cs.outline),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${topic.makeName} ${topic.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              // const Spacer(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatChip(
                    icon: Icons.help_outline_rounded,
                    label: '${topic.questionsCount} ${l10n.questionTypeLabel}',
                  ),
                  _StatChip(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: '${topic.answersCount} ${l10n.answerTypeLabel}',
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

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$rank',
        style: TextStyle(
          color: cs.onSecondaryContainer,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
