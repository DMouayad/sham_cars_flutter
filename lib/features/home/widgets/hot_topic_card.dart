import 'package:flutter/material.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/theme/constants.dart';

class HotTopicCard extends StatelessWidget {
  const HotTopicCard({super.key, required this.topic, this.onTap});

  final HotTopic topic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: cs.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${topic.makeName} ${topic.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${topic.questionsCount} سؤال • ${topic.answersCount} إجابة',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}
