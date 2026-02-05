import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class TrimCarouselCardSkeleton extends StatelessWidget {
  const TrimCarouselCardSkeleton({super.key, this.width = 210});
  final double width;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        width: width,
        child: Material(
          color: cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeConstants.cardRadius,
            side: BorderSide(color: cs.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AspectRatio(aspectRatio: 16 / 10, child: Bone.square()),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 1),
                    SizedBox(height: 6),
                    Bone.multiText(lines: 2),
                    SizedBox(height: 12),
                    Bone.text(words: 3),
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
