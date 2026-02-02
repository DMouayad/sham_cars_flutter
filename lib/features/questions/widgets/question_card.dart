import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';

import '../models.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.question, required this.onTap});

  final Question question;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
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
            // Title
            Text(
              question.title,
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Body preview
            if (question.body.isNotEmpty)
              Text(
                question.body,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 12),

            // Footer
            Row(
              children: [
                // Answers count
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: question.answersCount > 0
                        ? cs.primaryContainer
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 14,
                        color: question.answersCount > 0
                            ? cs.onPrimaryContainer
                            : cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${question.answersCount} ${_answersLabel(question.answersCount)}',
                        style: tt.labelSmall?.copyWith(
                          color: question.answersCount > 0
                              ? cs.onPrimaryContainer
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Author & date
                Text(
                  '${question.userName} • ${_formatDate(question.createdAt)}',
                  style: tt.labelSmall?.copyWith(color: cs.outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _answersLabel(int count) => switch (count) {
    0 => 'إجابة',
    1 => 'إجابة',
    2 => 'إجابتان',
    _ when count <= 10 => 'إجابات',
    _ => 'إجابة',
  };

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
