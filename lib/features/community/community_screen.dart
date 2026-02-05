import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/community/widgets/filters.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/question_card_skeleton.dart';

import 'community_cubit.dart';
import 'models.dart';
import 'widgets/add_review_sheet.dart';
import 'widgets/ask_question_sheet.dart';
import 'widgets/cards.dart';
import 'widgets/search_field.dart';
import '../questions/models.dart';
import '../reviews/models.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({
    super.key,
    required this.onOpenQuestion,
    required this.onOpenVehicle,
  });

  final void Function(int id) onOpenQuestion;
  final void Function(int id) onOpenVehicle;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  CommunityFilter _filter = CommunityFilter.all;
  bool _showFab = true;
  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _authNotifier = GetIt.I.get<AuthNotifier>();
    _authNotifier.addListener(_onAuthChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _authNotifier.removeListener(_onAuthChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    setState(() {}); // Rebuild to reflect login status changes
  }

  void _onScroll() {
    final shouldShow =
        _scrollController.position.userScrollDirection ==
            ScrollDirection.forward ||
        _scrollController.offset < 50;

    if (shouldShow != _showFab) {
      setState(() => _showFab = shouldShow);
    }

    // Lazy load questions when near bottom, unless reviews filter selected
    final nearBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 350;

    if (nearBottom && mounted) {
      final cubit = context.read<CommunityCubit>();

      if (_filter == CommunityFilter.questions) {
        cubit.loadMoreQuestions();
      } else if (_filter == CommunityFilter.reviews) {
        cubit.loadMoreReviews();
      } else {
        cubit.loadMoreQuestions();
        cubit.loadMoreReviews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _authNotifier.isLoggedIn;

    return Scaffold(
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          final isEmptyFeed = state.questions.isEmpty && state.reviews.isEmpty;

          if (state.isLoading && isEmptyFeed) {
            return ListView.separated(
              padding: EdgeInsets.all(ThemeConstants.p),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const QuestionCardSkeleton(),
            );
          }

          if (state.error != null && isEmptyFeed) {
            return _ErrorView(
              error: state.error!,
              onRetry: () => context.read<CommunityCubit>().load(),
            );
          }

          final items = _getFilteredItems(state);

          final canPaginate = state.searchQuery.isEmpty;

          final hasMore = switch (_filter) {
            CommunityFilter.questions => state.hasMoreQuestions,
            CommunityFilter.reviews => state.hasMoreReviews,
            CommunityFilter.all =>
              state.hasMoreQuestions || state.hasMoreReviews,
          };

          final isLoadingMore = switch (_filter) {
            CommunityFilter.questions => state.isLoadingMoreQuestions,
            CommunityFilter.reviews => state.isLoadingMoreReviews,
            CommunityFilter.all =>
              state.isLoadingMoreQuestions || state.isLoadingMoreReviews,
          };

          final showLoader = canPaginate && hasMore;
          final listCount = items.length + (showLoader ? 1 : 0);
          return RefreshIndicator(
            onRefresh: () => context.read<CommunityCubit>().load(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Stats Card
                SliverToBoxAdapter(
                  child: _StatsCard(
                    questionsCount: state.questions.length,
                    reviewsCount: state.reviews.length,
                  ),
                ),

                // Search
                PinnedHeaderSliver(
                  child: Container(
                    color: context.colorScheme.surface,
                    padding: const EdgeInsets.fromLTRB(
                      ThemeConstants.p,
                      8,
                      ThemeConstants.p,
                      12,
                    ),
                    child: Column(
                      spacing: 6,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchField(
                          controller: _searchController,
                          onChanged: (q) =>
                              context.read<CommunityCubit>().search(q),
                          onClear: () {
                            _searchController.clear();
                            context.read<CommunityCubit>().search('');
                          },
                        ),
                        CommunityFilters(
                          selected: _filter,
                          onChanged: (f) => setState(() => _filter = f),
                          questionsCount: state.filteredQuestions.length,
                          reviewsCount: state.filteredReviews.length,
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                if (items.isEmpty)
                  SliverFillRemaining(
                    child: _EmptyState(
                      isSearching: state.searchQuery.isNotEmpty,
                      filter: _filter,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.p,
                    ),
                    sliver: SliverList.separated(
                      itemCount: listCount,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        if (showLoader && i == items.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: isLoadingMore
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          );
                        }
                        return _buildItem(items[i]);
                      },
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _showFab ? 1 : 0,
          child: isLoggedIn
              ? _CommunitySpeedDial(
                  onAskQuestion: () => _showSheet(context, isQuestion: true),
                  onAddReview: () => _showSheet(context, isQuestion: false),
                )
              : FloatingActionButton.extended(
                  onPressed: () {
                    final returnTo = GoRouterState.of(context).uri.toString();
                    LoginRoute(redirectTo: returnTo).push(context);
                  },
                  label: const Text('Join to contribute'),
                  icon: const Icon(Icons.login),
                  backgroundColor: context.colorScheme.secondary,
                ),
        ),
      ),
    );
  }

  List<CommunityItem> _getFilteredItems(CommunityState state) {
    final List<CommunityItem> items = [];

    if (_filter == CommunityFilter.all ||
        _filter == CommunityFilter.questions) {
      items.addAll(state.filteredQuestions);
    }
    if (_filter == CommunityFilter.all || _filter == CommunityFilter.reviews) {
      items.addAll(state.filteredReviews);
    }

    // Sort by date (newest first)
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items;
  }

  Widget _buildItem(CommunityItem item) {
    return switch (item) {
      final Question question => QuestionCard(
        question: question,
        showQuestionBadge: true,
        onTap: () => widget.onOpenQuestion(question.id),
      ),
      final Review review => CommunityReviewCard(
        review: review,
        onTap: review.trimId != null
            ? (_) => widget.onOpenVehicle(review.trimId!)
            : null,
      ),
      CommunityItem() => const SizedBox.shrink(),
    };
  }

  Future<void> _showSheet(
    BuildContext context, {
    required bool isQuestion,
  }) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          isQuestion ? const AskQuestionSheet() : const AddReviewSheet(),
    );
    if (result == true && context.mounted) {
      context.read<CommunityCubit>().load();
    }
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.questionsCount, required this.reviewsCount});

  final int questionsCount;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(ThemeConstants.p),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primaryContainer, cs.primaryContainer.withOpacity(0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: ThemeConstants.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.forum_outlined,
              value: questionsCount,
              label: 'سؤال',
              color: cs.onPrimaryContainer,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: cs.onPrimaryContainer.withOpacity(0.2),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.rate_review_outlined,
              value: reviewsCount,
              label: 'تجربة',
              color: cs.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: color.withOpacity(0.8)),
        ),
      ],
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text('حدث خطأ', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isSearching, required this.filter});

  final bool isSearching;
  final CommunityFilter filter;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final (icon, title, subtitle) = isSearching
        ? (Icons.search_off, 'لا توجد نتائج', 'جرب كلمات بحث مختلفة')
        : switch (filter) {
            CommunityFilter.questions => (
              Icons.forum_outlined,
              'لا توجد أسئلة',
              'كن أول من يطرح سؤالاً!',
            ),
            CommunityFilter.reviews => (
              Icons.rate_review_outlined,
              'لا توجد تجارب',
              'شارك تجربتك مع الآخرين!',
            ),
            CommunityFilter.all => (
              Icons.people_outline,
              'لا يوجد محتوى',
              'ابدأ المحادثة!',
            ),
          };

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
