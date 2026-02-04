import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/reviews/widgets/review_card.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/community/widgets/ask_question_sheet.dart';
import 'package:sham_cars/features/community/widgets/add_review_sheet.dart';
import 'package:go_router/go_router.dart'; // Added GoRouter import for navigation
import 'package:sham_cars/widgets/scaffold_with_navbar.dart';

import 'cubits/trim_community_cubit.dart';

class TrimCommunityScreen extends StatefulWidget {
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
  State<TrimCommunityScreen> createState() => _TrimCommunityScreenState();
}

class _TrimCommunityScreenState extends State<TrimCommunityScreen> {
  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _authNotifier = GetIt.I.get<AuthNotifier>();
    _authNotifier.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authNotifier.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    setState(() {}); // Rebuild to reflect login status changes
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _authNotifier.isLoggedIn;
    return BlocProvider(
      create: (_) =>
          TrimCommunityCubit((context.read()))..load(trimId: widget.trimId),
      child: DefaultTabController(
        initialIndex: widget.initialTab,
        length: 2,
        child: Scaffold(
          body: BlocBuilder<TrimCommunityCubit, TrimCommunityState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: Text(widget.trimTitle),
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'التجارب'),
                        Tab(text: 'سؤال وجواب'),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(ThemeConstants.p),
                      child: _Body(state: state),
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: Builder(
            builder: (context) {
              if (isLoggedIn) {
                return _CommunitySpeedDial(
                  onAskQuestion: () => _showSheet(context, isQuestion: true),
                  onAddReview: () => _showSheet(context, isQuestion: false),
                );
              } else {
                return FloatingActionButton.extended(
                  onPressed: () => StatefulNavigationShell.of(
                    context,
                  ).goBranch(navigationShellIndex.profile),
                  label: const Text('Join to contribute'),
                  icon: const Icon(Icons.login),
                  // backgroundColor: context.colorScheme.secondary,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, {required bool isQuestion}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<TrimCommunityCubit>(), // Use TrimCommunityCubit
        child: isQuestion
            ? const AskQuestionSheet()
            : AddReviewSheet(
                preselectedTrimId: widget.trimId,
              ), // Needs preselectedTrimId
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});
  final TrimCommunityState state;

  @override
  Widget build(BuildContext context) {
    if (state.loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Center(child: Text('حدث خطأ: ${state.error}')),
      );
    }

    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 200,
      child: TabBarView(
        children: [
          _ReviewsList(reviews: state.reviews),
          _QuestionsList(questions: state.questions),
        ],
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  const _ReviewsList({required this.reviews});
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const Center(child: Text('لا توجد تجارب بعد'));

    return ListView.separated(
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => ReviewCard(review: reviews[i]),
    );
  }
}

class _QuestionsList extends StatelessWidget {
  const _QuestionsList({required this.questions});
  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: Text('لا توجد أسئلة بعد'));
    }

    return ListView.separated(
      itemCount: questions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) =>
          QuestionCard(question: questions[i], showContext: false),
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
