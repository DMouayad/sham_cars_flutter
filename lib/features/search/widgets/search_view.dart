import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/search/cubit/search_cubit.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'search_card_wrapper.dart';

const _fetchFullInfoMinSheetHeightExtent = 0.9;

class SearchResultsSection extends StatefulWidget {
  const SearchResultsSection({super.key, required this.searchCubit});
  final SearchCubit searchCubit;

  @override
  State<SearchResultsSection> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResultsSection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<SearchCubit, SearchState>(
          bloc: widget.searchCubit,
          builder: (context, state) {
            return Column(
              children: [
                if (state.isBusy || state.hasResults)
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      itemBuilder: (context, i) {
                        return AnimatedSwitcher(
                          key: Key('search-result-card-$i'),
                          duration: Duration(milliseconds: 300 * i),
                          child: state.isBusy
                              ? const _CardSkeleton()
                              : SearchCardWrapper(
                                  result: state.results[i],
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                        );
                      },
                      separatorBuilder: (context, _) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        );
                      },
                      itemCount: state.isBusy ? 6 : state.results.length,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(6);
    return Skeletonizer.zone(
      child: Card(
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone.square(
              size: 65,
              borderRadius: BorderRadius.circular(4),
              indent: 16,
              indentEnd: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(width: 120, fontSize: 16, borderRadius: borderRadius),
                const SizedBox(height: 5),
                Bone.text(width: 50, borderRadius: borderRadius),
                const SizedBox(height: 5),
                Bone.text(width: 240, borderRadius: borderRadius),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrollDownHint extends StatefulWidget {
  const _ScrollDownHint();

  @override
  State<_ScrollDownHint> createState() => _ScrollDownHintState();
}

class _ScrollDownHintState extends State<_ScrollDownHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final _tween = Tween(begin: const Offset(0, 1), end: const Offset(0, -2));
  late Timer timer;
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    _animationController.repeat(reverse: true);
    timer = Timer(const Duration(seconds: 10), () {
      if (_animationController.isAnimating) {
        _animationController.animateTo(1);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  context.l10n.sheetDragUpHint,
                  style: context.myTxtTheme.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _tween.animate(_animationController),
              child: const Icon(
                Icons.swipe_up_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
