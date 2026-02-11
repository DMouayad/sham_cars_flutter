import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/reviews/widgets/review_card.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/community/widgets/ask_question_sheet.dart';
import 'package:sham_cars/features/community/widgets/add_review_sheet.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';

import 'cubits/trim_community_cubit.dart';

class TrimCommunityScreen extends StatelessWidget {
  const TrimCommunityScreen({
    super.key,
    required this.trimId,
    required this.initialTab,
    required this.trimTitle,
  });

  final int trimId;
  final int initialTab;
  final String trimTitle;

  @override
  Widget build(BuildContext context) {
    final authNotifier = GetIt.I.get<AuthNotifier>();

    return BlocProvider(
      create: (_) => TrimCommunityCubit(context.read())..load(trimId: trimId),
      child: DefaultTabController(
        initialIndex: initialTab,
        length: 2,
        child: AnimatedBuilder(
          animation: authNotifier,
          builder: (context, _) {
            final isLoggedIn = authNotifier.isLoggedIn;

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverAppBar(
                        pinned: true,
                        title: Text(trimTitle),
                        forceElevated: innerBoxIsScrolled,
                        bottom: TabBar(
                          tabs: [
                            Tab(text: context.l10n.trimCommunityReviewsTab),
                            Tab(text: context.l10n.trimCommunityQaTab),
                          ],
                        ),
                      ),
                    ),
                  ];
                },

                body: BlocBuilder<TrimCommunityCubit, TrimCommunityState>(
                  builder: (context, state) {
                    if (state.loadingInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.error != null) {
                      return Center(child: Text('حدث خطأ: ${state.error}'));
                    }

                    return TabBarView(
                      children: [
                        _ReviewsTab(trimId: trimId),
                        _QuestionsTab(trimId: trimId),
                      ],
                    );
                  },
                ),
              ),

              floatingActionButton: isLoggedIn
                  ? _CommunitySpeedDial(
                      onAskQuestion: () async {
                        final result = await showSheet(
                          context,
                          isQuestion: true,
                          trimId: trimId,
                          trimTitle: trimTitle,
                        );
                        if (result == true && context.mounted) {
                          context.read<TrimCommunityCubit>().refreshAll();
                        }
                      },
                      onAddReview: () async {
                        final result = await showSheet(
                          context,
                          trimId: trimId,
                          isQuestion: false,
                          trimTitle: trimTitle,
                        );
                        if (result == true && context.mounted) {
                          context.read<TrimCommunityCubit>().refreshAll();
                        }
                      },
                    )
                  : FloatingActionButton.extended(
                      onPressed: () {
                        final returnTo = GoRouterState.of(
                          context,
                        ).uri.toString();
                        LoginRoute(redirectTo: returnTo).push(context);
                      },
                      label: Text(context.l10n.communityJoinToContribute),
                      icon: const Icon(Icons.login),
                    ),
            );
          },
        ),
      ),
    );
  }

  static Future<bool?> showSheet(
    BuildContext context, {
    required int trimId,
    required bool isQuestion,
    String? trimTitle,
  }) async {
    return await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => isQuestion
          ? AskQuestionSheet(
              preselectedTrimId: trimId,
              preselectedTrimTitle: trimTitle,
              lockTrim: true,
            )
          : AddReviewSheet(
              preselectedTrimId: trimId,
              preselectedTrimTitle: trimTitle,
              lockTrim: true,
            ),
    );
  }
}

class _ReviewsTab extends StatefulWidget {
  const _ReviewsTab({required this.trimId});
  final int trimId;

  @override
  State<_ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<_ReviewsTab> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final c = context.read<TrimCommunityCubit>();
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 250) {
      c.loadMoreReviews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrimCommunityCubit, TrimCommunityState>(
      buildWhen: (p, n) =>
          p.reviews != n.reviews ||
          p.loadingMoreReviews != n.loadingMoreReviews ||
          p.hasMoreReviews != n.hasMoreReviews,
      builder: (context, state) {
        if (state.reviews.isEmpty) {
          return Center(child: Text(context.l10n.trimCommunityNoReviews));
        }

        final count = state.reviews.length + (state.hasMoreReviews ? 1 : 0);

        return CustomScrollView(
          controller: _controller,
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(ThemeConstants.p),
              sliver: SliverList.separated(
                itemCount: count,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  if (i == state.reviews.length) {
                    return _BottomLoader(loading: state.loadingMoreReviews);
                  }
                  return ReviewCard(review: state.reviews[i]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuestionsTab extends StatefulWidget {
  const _QuestionsTab({required this.trimId});
  final int trimId;

  @override
  State<_QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<_QuestionsTab> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final c = context.read<TrimCommunityCubit>();
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 250) {
      c.loadMoreQuestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrimCommunityCubit, TrimCommunityState>(
      buildWhen: (p, n) =>
          p.questions != n.questions ||
          p.loadingMoreQuestions != n.loadingMoreQuestions ||
          p.hasMoreQuestions != n.hasMoreQuestions,
      builder: (context, state) {
        if (state.questions.isEmpty) {
          return Center(child: Text(context.l10n.trimCommunityNoQuestions));
        }

        final count = state.questions.length + (state.hasMoreQuestions ? 1 : 0);

        return CustomScrollView(
          controller: _controller,
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(ThemeConstants.p),
              sliver: SliverList.separated(
                itemCount: count,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  if (i == state.questions.length) {
                    return _BottomLoader(loading: state.loadingMoreQuestions);
                  }
                  return QuestionCard(
                    question: state.questions[i],
                    showContext: false,
                    onTap: () => QuestionDetailsRoute(
                      state.questions[i].id,
                    ).push(context),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader({required this.loading});
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (!loading) return const SizedBox(height: 10);

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _CommunitySpeedDial extends StatefulWidget {
  const _CommunitySpeedDial({
    required this.onAskQuestion,
    required this.onAddReview,
  });

  final VoidCallback onAskQuestion;
  final VoidCallback onAddReview;

  @override
  State<_CommunitySpeedDial> createState() => _CommunitySpeedDialState();
}

class _CommunitySpeedDialState extends State<_CommunitySpeedDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Speed dial options
        ScaleTransition(
          scale: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          alignment: Alignment.bottomRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SpeedDialOption(
                label: 'اطرح سؤالاً',
                icon: Icons.help_outline,
                color: cs.tertiaryContainer,
                onColor: cs.onTertiaryContainer,
                onTap: () {
                  _toggle();
                  widget.onAskQuestion();
                },
              ),
              const SizedBox(height: 12),
              _SpeedDialOption(
                label: 'أضف تجربة',
                icon: Icons.rate_review_outlined,
                color: cs.secondaryContainer,
                onColor: cs.onSecondaryContainer,
                onTap: () {
                  _toggle();
                  widget.onAddReview();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Main FAB
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0, // 45 degrees
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _SpeedDialOption extends StatelessWidget {
  const _SpeedDialOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.onColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color onColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          borderRadius: BorderRadius.circular(8),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: onColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          heroTag: label,
          backgroundColor: color,
          foregroundColor: onColor,
          onPressed: onTap,
          child: Icon(icon),
        ),
      ],
    );
  }
}
