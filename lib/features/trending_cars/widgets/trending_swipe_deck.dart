import 'package:flutter/material.dart';
import 'package:sham_cars/features/vehicle/models.dart';

import 'trending_deck_card.dart';

class TrendingSwipeDeck extends StatefulWidget {
  const TrendingSwipeDeck({
    super.key,
    required this.items,
    required this.height,
    required this.onTap,
    required this.inHome,
  });

  final List<CarTrimSummary> items;
  final double height;
  final void Function(CarTrimSummary trim, int rank) onTap;
  final bool inHome;
  @override
  State<TrendingSwipeDeck> createState() => _TrendingSwipeDeckState();
}

class _TrendingSwipeDeckState extends State<TrendingSwipeDeck> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        itemBuilder: (context, i) {
          final trim = widget.items[i];
          final rank = i + 1;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final page = _controller.hasClients
                  ? (_controller.page ?? _controller.initialPage.toDouble())
                  : 0.0;
              final distance = (page - i).abs().clamp(0.0, 1.0);

              final scale = 1.0 - (distance * 0.06); // 0.94..1.0
              final opacity = 1.0 - (distance * 0.25); // 0.75..1.0
              final dy = distance * 8.0; // slight drop for side cards

              return Transform.translate(
                offset: Offset(0, dy),
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 6),
              child: TrendingDeckCard(
                inHome: widget.inHome,
                trim: trim,
                rank: rank,
                height: widget.height,
                onTap: () => widget.onTap(trim, rank),
              ),
            ),
          );
        },
      ),
    );
  }
}
