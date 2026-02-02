import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/community/widgets/filters.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/utils.dart';

import 'community_cubit.dart';
import 'models.dart';
import 'widgets/add_review_sheet.dart';
import 'widgets/ask_question_sheet.dart';
import 'widgets/cards.dart';
import 'widgets/search_field.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow =
        _scrollController.position.userScrollDirection ==
            ScrollDirection.forward ||
        _scrollController.offset < 50;
    if (shouldShow != _showFab) {
      setState(() => _showFab = shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          if (state.isLoading && state.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.questions.isEmpty) {
            return _ErrorView(
              error: state.error!,
              onRetry: () => context.read<CommunityCubit>().load(),
            );
          }

          final items = _getFilteredItems(state);

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
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _buildItem(items[i]),
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
          child: _CommunitySpeedDial(
            onAskQuestion: () => _showSheet(context, isQuestion: true),
            onAddReview: () => _showSheet(context, isQuestion: false),
          ),
        ),
      ),
    );
  }

  List<CommunityItem> _getFilteredItems(CommunityState state) {
    final List<CommunityItem> items = [];

    if (_filter == CommunityFilter.all ||
        _filter == CommunityFilter.questions) {
      items.addAll(state.filteredQuestions.map(CommunityItem.question));
    }
    if (_filter == CommunityFilter.all || _filter == CommunityFilter.reviews) {
      items.addAll(state.filteredReviews.map(CommunityItem.review));
    }

    // Sort by date (newest first)
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items;
  }

  Widget _buildItem(CommunityItem item) {
    return switch (item) {
      QuestionItem(:final question) => CommunityQuestionCard(
        question: question,
        onTap: () => widget.onOpenQuestion(question.id),
      ),
      ReviewItem(:final review) => CommunityReviewCard(
        review: review,
        onTap: review.vehicle != null
            ? () => widget.onOpenVehicle(review.vehicle!.id)
            : null,
      ),
    };
  }

  void _showSheet(BuildContext context, {required bool isQuestion}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<CommunityCubit>(),
        child: isQuestion ? const AskQuestionSheet() : const AddReviewSheet(),
      ),
    );
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
