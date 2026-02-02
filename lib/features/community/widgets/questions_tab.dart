import 'package:flutter/material.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/theme/constants.dart';

class QuestionsTab extends StatelessWidget {
  const QuestionsTab({
    super.key,
    required this.questions,
    required this.onOpenQuestion,
    required this.onRefresh,
  });

  final List<Question> questions;
  final void Function(int id) onOpenQuestion;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return _EmptyState(
        icon: Icons.forum_outlined,
        title: 'لا توجد أسئلة',
        subtitle: 'كن أول من يطرح سؤالاً!',
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(ThemeConstants.p),
        itemCount: questions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => QuestionCard(
          question: questions[i],
          onTap: () => onOpenQuestion(questions[i].id),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: cs.outline),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.outline),
          ),
        ],
      ),
    );
  }
}
