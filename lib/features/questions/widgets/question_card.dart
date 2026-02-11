import 'package:flutter/material.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/date_time_text.dart';

enum QuestionCardVariant { normal, mine }

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    this.onTap,
    this.compact = true,
    this.showContext = true,
    this.showQuestionBadge = true,
    this.variant = QuestionCardVariant.normal,
    this.headerLabel,
  });

  final Question question;
  final VoidCallback? onTap;
  final bool compact;
  final bool showContext;
  final bool showQuestionBadge;

  final QuestionCardVariant variant;
  final String? headerLabel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final isMine = variant == QuestionCardVariant.mine;

    final hasContext =
        showContext &&
        ((question.modelName?.isNotEmpty ?? false) ||
            (question.trimName?.isNotEmpty ?? false));

    return Material(
      color: isMine ? cs.primaryContainer.withValues(alpha: 0.30) : cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.cardRadius,
        side: BorderSide(
          color: isMine
              ? cs.primary.withValues(alpha: 0.45)
              : cs.outlineVariant,
          width: isMine ? 1.2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isMine && headerLabel != null) ...[
                    Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        10,
                        6,
                        10,
                        6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Text(
                        headerLabel!,
                        style: tt.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (showQuestionBadge) ...[
                    Icon(Icons.help_outline, size: 18, color: Colors.green),
                    const SizedBox(width: 6),
                  ],

                  if (hasContext)
                    Expanded(
                      child: Text(
                        _contextText(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.labelLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    )
                  else
                    const Spacer(),

                  const SizedBox(width: 8),
                  Text(
                    DateTimeText.relativeOrShort(context, question.createdAt),
                    style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // BODY
              Text(
                question.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 6),

              Text(
                question.body,
                maxLines: compact ? 2 : 5,
                overflow: TextOverflow.ellipsis,
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 14),

              // FOOTER
              Row(
                children: [
                  _AvatarLetter(name: question.userName),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      question.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _StatPill(
                    icon: Icons.forum_outlined,
                    count: question.answersCount,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _contextText() {
    final model = (question.modelName ?? '').trim();
    final trim = (question.trimName ?? '').trim();

    if (model.isNotEmpty && trim.isNotEmpty) return '$model • $trim';
    if (model.isNotEmpty) return model;
    return trim;
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.count, required this.icon});
  final int count;
  final IconData icon;

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
          Icon(icon, size: 12, color: cs.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
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
      width: 28, // Standardized Size
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
