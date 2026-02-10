import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sham_cars/features/community/widgets/community_review_card.dart';
import 'package:sham_cars/features/hot_topics/featured_hot_topic_card.dart';
import 'package:sham_cars/features/questions/widgets/question_card.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/widgets/featured_trim_card.dart';
import 'package:sham_cars/features/vehicle/widgets/list_trim_card.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/question_card_skeleton.dart';
import 'package:sham_cars/features/reviews/widgets/review_card_skeleton.dart';

import 'home_cubit.dart';
import 'models.dart';
import 'widgets/featured_trim_card_skeleton.dart';
import 'widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onOpenTrim,
    required this.onOpenQuestion,
    required this.onViewAllVehicles,
    required this.onViewAllQuestions,
    required this.onViewAllHotTopics,
    required this.onOpenHotTopic,
    required this.onViewAllReviews,
  });

  final void Function(int trimId, [CarTrimSummary? summary]) onOpenTrim;
  final void Function(int questionId) onOpenQuestion;
  final VoidCallback onViewAllVehicles;
  final VoidCallback onViewAllQuestions;
  final VoidCallback onViewAllReviews;
  final VoidCallback onViewAllHotTopics;
  final void Function(HotTopic) onOpenHotTopic;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double _trendingCardHeight = 310;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _debouncer = Debouncer(milliseconds: 400);

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.error != null &&
              !state.hasData &&
              !state.showSearchResults) {
            return _ErrorView(
              title: l10n.homeErrorTitle,
              subtitle: l10n.homeErrorSubtitle,
              retryLabel: l10n.commonRetry,
              onRetry: () => context.read<HomeCubit>().load(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().refresh(),
            child: CustomScrollView(
              slivers: [
                // Search (pinned)
                PinnedHeaderSliver(
                  child: Container(
                    color: context.colorScheme.surface,
                    padding: const EdgeInsets.all(ThemeConstants.p),
                    child: _SearchField(
                      hintText: l10n.homeSearchHint,
                      controller: _searchController,
                      focusNode: _searchFocus,
                      isSearching: state.isSearching,
                      onChanged: (q) => _debouncer.run(() {
                        context.read<HomeCubit>().search(q);
                      }),
                      onClear: () {
                        _searchController.clear();
                        context.read<HomeCubit>().clearSearch();
                      },
                    ),
                  ),
                ),

                // Search results OR Home content
                if (state.showSearchResults)
                  ..._buildSearchResults(state)
                else if (state.isInitialLoading)
                  ..._buildHomeSkeleton()
                else if (state.data != null)
                  ..._buildHomeContent(state.data!),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSearchResults(HomeState state) {
    final l10n = context.l10n;

    if (state.isSearching) {
      return const [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ];
    }

    if (state.searchResults.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: _EmptyState(
            title: l10n.vehiclesSearchNoResultsTitle,
            subtitle: l10n.vehiclesSearchNoResultsSubtitle,
          ),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
          child: Text(
            l10n.homeSearchResultsCount(state.searchResults.length),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
        sliver: SliverList.separated(
          itemCount: state.searchResults.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final trim = state.searchResults[i];
            return TrimListCard(
              trim: trim,
              onTap: () => widget.onOpenTrim(trim.id, trim),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _buildHomeSkeleton() {
    final l10n = context.l10n;

    return [
      // Trending skeleton
      SliverToBoxAdapter(
        child: SectionHeader(
          title: l10n.homeTrendingTitle,
          onTap: widget.onViewAllVehicles,
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: _trendingCardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
            itemCount: 5,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, _) => const FeaturedTrimCardSkeleton(
              width: 260,
              height: _trendingCardHeight,
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),

      // Hot topics skeleton
      SliverToBoxAdapter(
        child: SectionHeader(
          title: l10n.commonHotTopics,
          onTap: widget.onViewAllQuestions,
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
        sliver: SliverList.separated(
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, _) => const FeaturedTrimCardSkeleton(height: 132),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),

      // Latest questions skeleton
      SliverToBoxAdapter(
        child: SectionHeader(
          title: l10n.homeLatestQuestionsTitle,
          onTap: widget.onViewAllQuestions,
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
        sliver: SliverList.separated(
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, _) => const QuestionCardSkeleton(),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),

      // Latest reviews skeleton
      SliverToBoxAdapter(
        child: SectionHeader(
          title: l10n.homeLatestReviewsTitle,
          onTap: widget.onViewAllReviews,
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
        sliver: SliverList.separated(
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, _) => const ReviewCardSkeleton(compact: true),
        ),
      ),
    ];
  }

  List<Widget> _buildHomeContent(HomeData data) {
    final l10n = context.l10n;

    return [
      // Trending
      if (data.trendingTrims.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: SectionHeader(
            title: l10n.homeTrendingTitle,
            onTap: widget.onViewAllVehicles,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: _trendingCardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
              itemCount: data.trendingTrims.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final trim = data.trendingTrims[i];
                return FeaturedTrimCard(
                  width: 260,
                  height: _trendingCardHeight,
                  trim: trim,
                  onTap: () => widget.onOpenTrim(trim.id, trim),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],

      // Hot Topics
      if (data.hotTopics.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: SectionHeader(
            title: l10n.commonHotTopics,
            onTap: widget.onViewAllHotTopics,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 132,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
              scrollDirection: Axis.horizontal,
              itemCount: data.hotTopics.take(10).length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(
                width: 260,
                child: HotTopicFeaturedCard(
                  topic: data.hotTopics[i],
                  rank: i + 1,
                  onTap: () => widget.onOpenHotTopic.call(data.hotTopics[i]),
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],

      // Latest Questions
      if (data.latestQuestions.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: SectionHeader(
            title: l10n.homeLatestQuestionsTitle,
            onTap: widget.onViewAllQuestions,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
          sliver: SliverList.separated(
            itemCount: data.latestQuestions.take(3).length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final q = data.latestQuestions[i];
              return QuestionCard(
                question: q,
                compact: true,
                onTap: () => widget.onOpenQuestion(q.id),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],

      // Latest Reviews
      if (data.latestReviews.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: SectionHeader(
            title: l10n.homeLatestReviewsTitle,
            onTap: widget.onViewAllReviews,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
          sliver: SliverList.separated(
            itemCount: data.latestReviews.take(3).length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final r = data.latestReviews[i];
              return CommunityReviewCard(review: r, onTap: widget.onOpenTrim);
            },
          ),
        ),
      ],
    ];
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.p),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 56, color: cs.outline),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.title,
    required this.subtitle,
    required this.retryLabel,
    required this.onRetry,
  });

  final String title;
  final String subtitle;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.p),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: cs.error),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

// Search field with loading indicator
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.isSearching,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSearching;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: isSearching
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.rCard),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.colorScheme.outline),
          borderRadius: BorderRadius.circular(ThemeConstants.rCard),
        ),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
      ),
    );
  }
}

// Simple debouncer
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
