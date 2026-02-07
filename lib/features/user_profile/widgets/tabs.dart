import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/common/paged_state.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/reviews/widgets/review_card.dart';
import 'package:sham_cars/features/reviews/widgets/review_card_skeleton.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/user_profile/cubits/my_answered_questions_cubit.dart';
import 'package:sham_cars/features/user_profile/cubits/my_questions_cubit.dart';
import 'package:sham_cars/features/user_profile/cubits/my_reviews_cubit.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/question_card_skeleton.dart';

import 'empty_tab.dart';

class MyReviewsTab extends StatefulWidget {
  const MyReviewsTab({super.key});

  @override
  State<MyReviewsTab> createState() => _MyReviewsTabState();
}

class _MyReviewsTabState extends State<MyReviewsTab> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 250) {
      context.read<MyReviewsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<MyReviewsCubit, PagedState<Review>>(
      builder: (context, state) {
        if (state.loadingInitial && state.items.isEmpty) {
          return ListView.separated(
            padding: const EdgeInsets.all(ThemeConstants.p),
            itemCount: 6,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, _) => const ReviewCardSkeleton(),
          );
        }

        if (state.items.isEmpty) {
          return EmptyTab(
            title: l10n.profileEmptyMyReviewsTitle,
            subtitle: l10n.profileEmptyMyReviewsSubtitle,
            actionText: l10n.profileBrowseCarsCta,
            onAction: () => const VehiclesRoute().go(context),
          );
        }

        final count = state.items.length + (state.hasMore ? 1 : 0);

        return RefreshIndicator(
          onRefresh: () => context.read<MyReviewsCubit>().refresh(),
          child: ListView.separated(
            controller: _scroll,
            padding: const EdgeInsets.all(ThemeConstants.p),
            itemCount: count,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == state.items.length) {
                return Center(
                  child: state.loadingMore
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const SizedBox.shrink(),
                );
              }

              final r = state.items[i];
              return ReviewCard(
                review: r,
                onTap: r.trimId == null
                    ? null
                    : () => VehicleDetailsRoute(id: r.trimId!).push(context),
              );
            },
          ),
        );
      },
    );
  }
}

class MyQuestionsTab extends StatefulWidget {
  const MyQuestionsTab({super.key});

  @override
  State<MyQuestionsTab> createState() => _MyQuestionsTabState();
}

class _MyQuestionsTabState extends State<MyQuestionsTab> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 250) {
      context.read<MyQuestionsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<MyQuestionsCubit, PagedState<Question>>(
      builder: (context, state) {
        if (state.loadingInitial && state.items.isEmpty) {
          return ListView.separated(
            padding: const EdgeInsets.all(ThemeConstants.p),
            itemCount: 6,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, _) => const QuestionCardSkeleton(),
          );
        }

        if (state.items.isEmpty) {
          return EmptyTab(
            title: l10n.profileEmptyMyQuestionsTitle,
            subtitle: l10n.profileEmptyMyQuestionsSubtitle,
            actionText: l10n.profileAskQuestionCta,
            onAction: () => const CommunityRoute().go(context),
          );
        }

        final count = state.items.length + (state.hasMore ? 1 : 0);

        return RefreshIndicator(
          onRefresh: () => context.read<MyQuestionsCubit>().refresh(),
          child: ListView.separated(
            controller: _scroll,
            padding: const EdgeInsets.all(ThemeConstants.p),
            itemCount: count,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == state.items.length) {
                return Center(
                  child: state.loadingMore
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const SizedBox.shrink(),
                );
              }

              final q = state.items[i];
              return QuestionCard(
                question: q,
                showContext: true,
                onTap: () => QuestionDetailsRoute(q.id).go(context),
              );
            },
          ),
        );
      },
    );
  }
}

class MyAnsweredQuestionsTab extends StatefulWidget {
  const MyAnsweredQuestionsTab({super.key});

  @override
  State<MyAnsweredQuestionsTab> createState() => _MyAnsweredQuestionsTabState();
}

class _MyAnsweredQuestionsTabState extends State<MyAnsweredQuestionsTab> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 250) {
      context.read<MyAnsweredQuestionsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<MyAnsweredQuestionsCubit, PagedState<Question>>(
      builder: (context, state) {
        if (state.loadingInitial && state.items.isEmpty) {
          return ListView.separated(
            padding: const EdgeInsets.all(ThemeConstants.p),
            itemCount: 6,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, _) => const QuestionCardSkeleton(),
          );
        }

        if (state.items.isEmpty) {
          return EmptyTab(
            title: l10n.profileEmptyMyAnsweredTitle,
            subtitle: l10n.profileEmptyMyAnsweredSubtitle,
            actionText: l10n.profileBrowseCommunityCta,
            onAction: () => const CommunityRoute().go(context),
          );
        }

        final count = state.items.length + (state.hasMore ? 1 : 0);

        return RefreshIndicator(
          onRefresh: () => context.read<MyAnsweredQuestionsCubit>().refresh(),
          child: ListView.separated(
            controller: _scroll,
            padding: const EdgeInsets.all(ThemeConstants.p),
            itemCount: count,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == state.items.length) {
                return Center(
                  child: state.loadingMore
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const SizedBox.shrink(),
                );
              }

              final q = state.items[i];
              return QuestionCard(
                question: q,
                showContext: true,
                onTap: () => QuestionDetailsRoute(q.id).go(context),
              );
            },
          ),
        );
      },
    );
  }
}
