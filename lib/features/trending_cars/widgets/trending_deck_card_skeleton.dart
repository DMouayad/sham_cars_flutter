import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class TrendingDeckCardSkeleton extends StatelessWidget {
  const TrendingDeckCardSkeleton({super.key, required this.height, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        height: height,
        width: width,
        child: Material(
          color: cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeConstants.cardRadius,
            side: BorderSide(color: cs.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Top badges row (rank + rating)
                const Row(
                  children: [
                    Bone(
                      width: 44,
                      height: 26,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    Spacer(),
                    Bone(
                      width: 78,
                      height: 26,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Image area
                const Expanded(
                  child: Bone(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom "info panel" (approximate overlay content)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone.text(words: 1), // make
                      SizedBox(height: 8),
                      Bone.text(words: 3), // title
                      SizedBox(height: 6),
                      Bone.text(words: 2), // meta
                      SizedBox(height: 10),

                      // spec pills row
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Bone(
                            width: 96,
                            height: 28,
                            borderRadius: BorderRadius.all(
                              Radius.circular(999),
                            ),
                          ),
                          Bone(
                            width: 96,
                            height: 28,
                            borderRadius: BorderRadius.all(
                              Radius.circular(999),
                            ),
                          ),
                          Bone(
                            width: 96,
                            height: 28,
                            borderRadius: BorderRadius.all(
                              Radius.circular(999),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(child: Bone.text(words: 2)), // price
                          SizedBox(width: 8),
                          Bone.icon(size: 20), // chevron
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
