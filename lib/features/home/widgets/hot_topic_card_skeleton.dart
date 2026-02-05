import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class HotTopicCardSkeleton extends StatelessWidget {
  const HotTopicCardSkeleton({super.key});

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
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Bone.square(size: 40),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 3),
                    SizedBox(height: 8),
                    Bone.text(words: 2),
                  ],
                ),
              ),
              Bone.square(size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
