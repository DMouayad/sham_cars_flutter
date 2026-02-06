import 'package:flutter/material.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/reviews/widgets/review_card.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';

class SectionHeaderRow extends StatelessWidget {
  const SectionHeaderRow({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        TextButton(
          onPressed: onViewAll,
          child: Text(context.l10n.viewAllBtnLabel),
        ),
      ],
    );
  }
}

class ReviewsPreview extends StatelessWidget {
  const ReviewsPreview({
    super.key,
    required this.items,
    required this.onViewAll,
  });

  final List<Review> items;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyBox(
        title: context.l10n.trimCommunityNoReviews,
        buttonText: context.l10n.viewAllBtnLabel,
        onPressed: onViewAll,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderRow(
          title: context.l10n.trimCommunityReviewsTab,
          onViewAll: onViewAll,
        ),
        const SizedBox(height: 10),
        ...items.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ReviewCard(review: r),
          ),
        ),
      ],
    );
  }
}

class QuestionsPreview extends StatelessWidget {
  const QuestionsPreview({
    super.key,
    required this.items,
    required this.onViewAll,
  });

  final List<Question> items;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyBox(
        title: context.l10n.trimCommunityNoQuestions,
        buttonText: context.l10n.viewAllBtnLabel,
        onPressed: onViewAll,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderRow(
          title: context.l10n.trimCommunityQaTab,
          onViewAll: onViewAll,
        ),
        const SizedBox(height: 10),
        ...items.map(
          (q) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: QuestionCard(
              question: q,
              showContext: false,
              onTap: () => QuestionDetailsRoute(q.id).push(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({
    required this.title,
    required this.buttonText,
    required this.onPressed,
  });
  final String title;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: ThemeConstants.cardRadius,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          TextButton(onPressed: onPressed, child: Text(buttonText)),
        ],
      ),
    );
  }
}
