import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class TrimListCardSkeleton extends StatelessWidget {
  const TrimListCardSkeleton({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image thumb bone
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Bone(width: 96, height: 76),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 1), // make
                    const SizedBox(height: 6),
                    Bone.multiText(lines: 2), // display name
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        Bone.text(words: 2),
                        Bone.text(words: 2),
                        Bone.text(words: 2),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Bone.text(words: 2), // price
                        Spacer(),
                        Bone.square(size: 18), // chevron placeholder
                      ],
                    ),
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
