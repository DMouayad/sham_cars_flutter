import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class CommunityReviewCardSkeleton extends StatelessWidget {
  const CommunityReviewCardSkeleton({super.key});

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
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header row
              Row(
                children: [
                  Bone.circle(size: 28),
                  SizedBox(width: 10),
                  Expanded(child: Bone.text(words: 2)),
                  SizedBox(width: 10),
                  Bone.text(words: 1),
                ],
              ),
              SizedBox(height: 10),
              Bone.text(words: 3), // vehicle line
              SizedBox(height: 8),
              Bone.multiText(lines: 2), // comment
            ],
          ),
        ),
      ),
    );
  }
}
