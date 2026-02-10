import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class TrendingTrimListCardSkeleton extends StatelessWidget {
  const TrendingTrimListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      child: Material(
        color: cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.cardRadius,
          side: BorderSide(color: cs.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          constraints: const BoxConstraints(minHeight: 160),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top content row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumb + rank (match 112x112)
                  Stack(
                    children: const [
                      Bone(
                        width: 112,
                        height: 112,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      PositionedDirectional(
                        start: 10,
                        top: 10,
                        child: Bone(
                          width: 44,
                          height: 26,
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                        ),
                      ),
                      PositionedDirectional(
                        end: 10,
                        bottom: 10,
                        child: Bone.square(
                          size: 20,
                        ), // trending icon placeholder
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Right column
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Make + rating pill
                        Row(
                          children: [
                            Expanded(child: Bone.text(words: 1)),
                            SizedBox(width: 8),
                            Bone(
                              width: 78,
                              height: 28,
                              borderRadius: BorderRadius.all(
                                Radius.circular(999),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        // Title (2 lines)
                        Bone.text(words: 3),
                        SizedBox(height: 6),
                        Bone.text(words: 2),

                        SizedBox(height: 6),

                        // Meta line
                        Bone.text(words: 2),

                        SizedBox(height: 6),

                        // Specs pills row (fixed height)
                        SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Flexible(
                                child: Bone(
                                  width: 60,
                                  height: 30,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(999),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Bone(
                                  width: 60,
                                  height: 30,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(999),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Bone(
                                  width: 60,
                                  height: 30,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(999),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),

              // Bottom price row
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Bone.text(words: 2), Bone.icon(size: 20)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
