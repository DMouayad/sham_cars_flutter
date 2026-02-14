import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/features/vehicle/cubits/also_liked_trims_cubit.dart';

import 'trim_carousel_card.dart';
import 'trim_carousel_card_skeleton.dart';

class AlsoLikedTrimsSection extends StatefulWidget {
  const AlsoLikedTrimsSection({super.key});

  @override
  State<AlsoLikedTrimsSection> createState() => _AlsoLikedTrimsSectionState();
}

class _AlsoLikedTrimsSectionState extends State<AlsoLikedTrimsSection> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<AlsoLikedTrimsCubit>();
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 250) {
      cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<AlsoLikedTrimsCubit, AlsoLikedTrimsState>(
      builder: (context, st) {
        if (st.loadingInitial && st.items.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Title(text: l10n.vehicleDetailsAlsoLikedTitle),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.p,
                  ),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, _) => const TrimCarouselCardSkeleton(),
                ),
              ),
            ],
          );
        }

        if (st.items.isEmpty) return const SizedBox.shrink();

        final count = st.items.length + (st.hasMore ? 1 : 0);
        double alsoLikedSectionHeight = 240;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title(text: l10n.vehicleDetailsAlsoLikedTitle),
            const SizedBox(height: 10),
            SizedBox(
              height: alsoLikedSectionHeight,
              child: ListView.separated(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: count,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  if (i == st.items.length) {
                    return Center(
                      child: st.loadingMore
                          ? const TrimCarouselCardSkeleton()
                          : const SizedBox.shrink(),
                    );
                  }

                  final trim = st.items[i];
                  return TrimCarouselCard(
                    trim: trim,
                    height: alsoLikedSectionHeight,
                    onTap: () => VehicleDetailsRoute(
                      id: trim.id,
                      $extra: trim,
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

class _Title extends StatelessWidget {
  const _Title({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
    );
  }
}
