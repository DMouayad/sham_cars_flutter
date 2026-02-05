import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class QuestionCardSkeleton extends StatelessWidget {
  const QuestionCardSkeleton({super.key});

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
            children: const [
              // optional context line (if you show it sometimes)
              Bone.text(words: 3),
              SizedBox(height: 8),

              // title (2 lines)
              Bone.multiText(lines: 2),
              SizedBox(height: 10),

              // body preview (2 lines)
              Bone.multiText(lines: 2),
              SizedBox(height: 12),

              // footer row
              Row(
                children: [
                  Bone.circle(size: 34),
                  SizedBox(width: 10),
                  Expanded(child: Bone.text(words: 2)),
                  SizedBox(width: 10),
                  Bone.text(words: 1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
