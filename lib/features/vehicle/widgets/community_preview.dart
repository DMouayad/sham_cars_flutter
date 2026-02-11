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
    required this.onAdd,
    this.addTooltip,
    required this.addBtnTitle,
  });

  final String title;
  final VoidCallback onViewAll;
  final VoidCallback onAdd;
  final String? addTooltip;
  final String addBtnTitle;
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

        TextButton.icon(
          onPressed: onAdd,
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              context.colorScheme.secondary,
            ),
          ),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text(
            addBtnTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        TextButton(
          onPressed: onViewAll,
          child: Text(
            context.l10n.viewAllBtnLabel,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
    required this.onAdd,
    required this.userReview,
  });

  final List<Review> items;
  final Review? userReview;

  final VoidCallback onViewAll;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyBox(
        title: context.l10n.trimCommunityNoReviews,
        buttonText: context.l10n.vehicleDetailsWriteReview,
        onPressed: onAdd,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderRow(
          title: context.l10n.trimCommunityReviewsTab,
          onViewAll: onViewAll,
          onAdd: onAdd,
          addBtnTitle: context.l10n.vehicleDetailsWriteReview,
        ),
        if (userReview != null) ...[
          ReviewCard(
            review: userReview!,
            variant: ReviewCardVariant.mine,
            headerLabel: context.l10n.yourReviewLabel,
            compact: true,
          ),
          const SizedBox(height: 10),
        ],
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
    required this.items, // other users' questions (already filtered)
    required this.myQuestions, // current user's questions for this trim
    required this.onViewAll,
    required this.onAddNew,
  });

  final List<Question> items;
  final List<Question> myQuestions;
  final VoidCallback onViewAll;
  final VoidCallback onAddNew;

  @override
  Widget build(BuildContext context) {
    final isEmpty = items.isEmpty && myQuestions.isEmpty;

    if (isEmpty) {
      return _EmptyBox(
        title: context.l10n.trimCommunityNoQuestions,
        buttonText: context.l10n.vehicleDetailsAskQuestion,
        onPressed: onAddNew,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderRow(
          title: context.l10n.trimCommunityQaTab,
          onViewAll: onViewAll,
          onAdd: onAddNew,
          addBtnTitle: context.l10n.vehicleDetailsAskQuestion,
        ),
        const SizedBox(height: 10),

        if (myQuestions.isNotEmpty) ...[
          // Text(
          //   context.l10n.yourQuestionsSectionTitle,
          //   style: Theme.of(
          //     context,
          //   ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
          // ),
          // const SizedBox(height: 8),
          _MyQuestionsCarousel(items: myQuestions),
          const SizedBox(height: 14),
        ],

        ...items.map(
          (q) => Padding(
            key: ValueKey(q.id),
            padding: const EdgeInsets.only(bottom: 10),
            child: QuestionCard(
              question: q,
              showContext: false,
              compact: true,
              onTap: () => QuestionDetailsRoute(q.id).push(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _MyQuestionsCarousel extends StatefulWidget {
  const _MyQuestionsCarousel({required this.items});
  final List<Question> items;

  @override
  State<_MyQuestionsCarousel> createState() => _MyQuestionsCarouselState();
}

class _MyQuestionsCarouselState extends State<_MyQuestionsCarousel> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: PageView needs a bounded height
    const height = 180.0;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final q = widget.items[i];
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: QuestionCard(
                  question: q,
                  showContext: false,
                  compact: true,
                  variant: QuestionCardVariant.mine,
                  headerLabel: context.l10n.yourQuestionLabel,
                  onTap: () => QuestionDetailsRoute(q.id).push(context),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _DotsIndicator(activeIndex: _index, count: widget.items.length),
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.activeIndex, required this.count});
  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (count <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.outlineVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
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
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
