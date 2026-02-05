import 'package:flutter/material.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/date_time_text.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    this.onTap,
    this.compact = true,
    this.showContext = true,
    this.showQuestionBadge = false,
  });

  final Question question;
  final VoidCallback? onTap;

  /// compact=true is best for vehicle details previews (latest 2).
  final bool compact;

  /// show model/trim context if provided by API (useful in global questions list).
  final bool showContext;

  final bool showQuestionBadge;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final hasContext =
        showContext &&
        ((question.modelName?.isNotEmpty ?? false) ||
            (question.trimName?.isNotEmpty ?? false));

    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: ThemeConstants.cardRadius,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Type badge
              if (showQuestionBadge) const Icon(Icons.help_outline, size: 18),
              if (hasContext) ...[
                Text(
                  _contextText(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
              ],
              Text(
                DateTimeText.relativeOrShort(context, question.createdAt),
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            question.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 8),

          // Body preview
          Text(
            question.body,
            maxLines: compact ? 2 : 5,
            overflow: TextOverflow.ellipsis,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.55,
            ),
          ),

          const SizedBox(height: 12),

          // Footer: user + answers + date
          Row(
            children: [
              _AvatarLetter(name: question.userName),
              const SizedBox(width: 10),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _AnswersPill(count: question.answersCount),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      borderRadius: ThemeConstants.cardRadius,
      child: card,
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

class _AnswersPill extends StatelessWidget {
  const _AnswersPill({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.forum_outlined, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
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
        // color: cs.surf,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          // color: cs.onPrimaryContainer,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
