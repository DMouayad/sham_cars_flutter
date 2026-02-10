import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/home/widgets/custom_drawer.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/utils.dart';

import 'trending_cars_cubit.dart';
import 'widgets/trending_deck_card.dart';
import 'widgets/trending_deck_card_skeleton.dart';
import 'widgets/trending_trim_list_card.dart';
import 'widgets/trending_trim_list_card_skeleton.dart';

class TrendingCarsScreen extends StatefulWidget {
  const TrendingCarsScreen({super.key, required this.onOpenVehicle});
  final void Function(int id) onOpenVehicle;

  @override
  State<TrendingCarsScreen> createState() => _TrendingCarsScreenState();
}

class _TrendingCarsScreenState extends State<TrendingCarsScreen> {
  static const int _deckCount = 5;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<TrendingCarsCubit>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 280) {
      cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final deckHeight = (MediaQuery.sizeOf(context).height * 0.60).clamp(
      320.0,
      440.0,
    );

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(title: Text(l10n.trendingCarsScreenTitle)),
      body: BlocBuilder<TrendingCarsCubit, TrendingCarsState>(
        builder: (context, state) {
          final items = state.items;

          return RefreshIndicator(
            onRefresh: () => context.read<TrendingCarsCubit>().refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Initial loading skeletons
                if (state.loading && items.isEmpty) ...[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: deckHeight,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.90),
                        itemCount: _deckCount,
                        itemBuilder: (_, _) => Padding(
                          padding: const EdgeInsetsDirectional.only(end: 6),
                          child: TrendingDeckCardSkeleton(height: deckHeight),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.p,
                    ),
                    sliver: SliverList.separated(
                      itemCount: 6,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, _) =>
                          const TrendingTrimListCardSkeleton(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ] else if (items.isEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(ThemeConstants.p),
                      child: Text(l10n.trendingCarsEmpty),
                    ),
                  ),
                ] else ...[
                  // Deck top 5
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top: 12),
                      child: SizedBox(
                        height: deckHeight,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.90),
                          itemCount: items.take(_deckCount).length,
                          itemBuilder: (context, i) {
                            final trim = items[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: TrendingDeckCard(
                                trim: trim,
                                rank: i + 1,
                                height: deckHeight,
                                onTap: () => widget.onOpenVehicle(trim.id),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // List (skip top 5)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.p,
                    ),
                    sliver: SliverList.separated(
                      itemCount:
                          (items.length > _deckCount
                              ? (items.length - _deckCount)
                              : 0) +
                          (state.loadingMore ? 3 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final listLen = (items.length - _deckCount).clamp(
                          0,
                          9999,
                        );

                        if (i >= listLen) {
                          return const TrendingTrimListCardSkeleton();
                        }

                        final trim = items[_deckCount + i];
                        final rank = _deckCount + i + 1;

                        return TrendingTrimListCard(
                          rank: rank,
                          trim: trim,
                          onTap: () => widget.onOpenVehicle(trim.id),
                        );
                      },
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
