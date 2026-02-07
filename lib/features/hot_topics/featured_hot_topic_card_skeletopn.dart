import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class HotTopicFeaturedCardSkeleton extends StatelessWidget {
  const HotTopicFeaturedCardSkeleton({super.key, this.height = 132});

  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: height, // important for horizontal list usage
      child: Skeletonizer(
        enabled: true,
        child: Material(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: ThemeConstants.cardRadius,
            side: BorderSide(color: cs.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: const Padding(
            padding: EdgeInsets.all(12), // tighter than 14
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row (matches rank badge height ~34)
                Row(
                  children: [
                    Bone.square(
                      size: 34,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    Spacer(),
                    Bone(
                      width: 44,
                      height: 20,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    SizedBox(width: 8),
                    Bone.square(size: 18),
                  ],
                ),
                SizedBox(height: 8),

                // Title placeholder (2 lines, tight spacing)
                Bone.text(words: 3),
                SizedBox(height: 6),
                Bone.text(words: 2),

                Spacer(),

                // Bottom stat pills (shorter height to avoid overflow)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Bone(
                      width: 110,
                      height: 24,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    Bone(
                      width: 110,
                      height: 24,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
