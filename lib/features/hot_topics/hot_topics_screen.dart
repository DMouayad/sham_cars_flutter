import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/home/widgets/hot_topic_card_skeleton.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/utils.dart';

import 'featured_hot_topic_card.dart';
import 'featured_hot_topic_card_skeletopn.dart';
import 'hot_topic_list_tile.dart';
import 'hot_topics_cubit.dart';

class HotTopicsScreen extends StatelessWidget {
  const HotTopicsScreen({super.key, required this.onTopicTap});
  final void Function(HotTopic topic) onTopicTap;

  static const _featuredHeight = 142.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.commonHotTopics)),
      body: BlocBuilder<HotTopicsCubit, HotTopicsState>(
        builder: (context, state) {
          final query = state.query.trim();
          final searching = query.isNotEmpty;

          // Use full list for Top 3 (not the filtered list)
          final top3 = (!searching && state.items.length >= 3)
              ? state.items.take(3).toList()
              : const <HotTopic>[];

          // For the main list:
          // - if searching => use filtered
          // - else => use all topics except top 3
          final listItems = searching
              ? state.filtered
              : (state.items.length > 3
                    ? state.items.skip(3).toList()
                    : state.items);

          return NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.pixels >= (n.metrics.maxScrollExtent - 280)) {
                context.read<HotTopicsCubit>().loadMore();
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () => context.read<HotTopicsCubit>().refresh(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(ThemeConstants.p),
                      child: TextField(
                        onChanged: context.read<HotTopicsCubit>().setQuery,
                        decoration: InputDecoration(
                          hintText: l10n.hotTopicsSearchHint,
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Initial loading
                  if (state.loading && state.items.isEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.p,
                      ),
                      sliver: SliverList.separated(
                        itemCount: 3,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, _) =>
                            const HotTopicFeaturedCardSkeleton(
                              height: _featuredHeight,
                            ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.p,
                      ),
                      sliver: SliverList.separated(
                        itemCount: 6,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, _) => const HotTopicListTileSkeleton(),
                      ),
                    ),
                  ] else if (state.items.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(ThemeConstants.p),
                        child: Text(l10n.hotTopicsEmpty),
                      ),
                    )
                  else ...[
                    // Top 3 featured (only when not searching)
                    if (top3.isNotEmpty) ...[
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.p,
                        ),
                        sliver: SliverList.separated(
                          itemCount: top3.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final topic = top3[i];
                            return SizedBox(
                              height: _featuredHeight,
                              child: HotTopicFeaturedCard(
                                topic: topic,
                                rank: i + 1,
                                onTap: () => onTopicTap(topic),
                              ),
                            );
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    ],

                    // Rest list + load-more skeleton footer
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.p,
                      ),
                      sliver: SliverList.separated(
                        itemCount:
                            listItems.length + (state.loadingMore ? 3 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          if (i >= listItems.length) {
                            return const HotTopicListTileSkeleton();
                          }

                          final topic = listItems[i];

                          final rank = searching
                              ? (i + 1)
                              : (top3.isNotEmpty ? (4 + i) : (i + 1));

                          return HotTopicListTile(
                            topic: topic,
                            rank: rank,
                            onTap: () => onTopicTap(topic),
                          );
                        },
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
