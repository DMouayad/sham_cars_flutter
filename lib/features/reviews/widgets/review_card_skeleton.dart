import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class ReviewCardSkeleton extends StatelessWidget {
  const ReviewCardSkeleton({super.key, this.compact = false});

  final bool compact;

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
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header: avatar + name/date + rating
              const Row(
                children: [
                  Bone.circle(size: 34),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(words: 2),
                        SizedBox(height: 6),
                        Bone.text(words: 1),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Bone.text(words: 1),
                ],
              ),
              const SizedBox(height: 12),

              // body (3-5 lines depending on compact)
              Bone.multiText(lines: compact ? 3 : 5),
            ],
          ),
        ),
      ),
    );
  }
}
