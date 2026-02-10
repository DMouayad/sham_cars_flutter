import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class TrendingTrimCardSkeleton extends StatelessWidget {
  const TrendingTrimCardSkeleton({
    super.key,
    this.width = 260,
    this.height = 292,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeConstants.cardRadius,
            side: BorderSide(color: cs.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image skeleton
              const AspectRatio(aspectRatio: 16 / 10, child: Bone.square()),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Bone.text(words: 1), // make
                    SizedBox(height: 6),
                    Bone.multiText(lines: 2), // title
                    SizedBox(height: 10),
                    Bone.text(words: 3), // chips row placeholder
                    SizedBox(height: 12),
                    Bone.text(words: 2), // price
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
