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
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: thumb + text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone(
                    width: 92,
                    height: 72,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(words: 1), // make
                        SizedBox(height: 6),
                        Bone.multiText(lines: 2), // title
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Specs chips placeholders
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  Bone(
                    width: 55,
                    height: 24,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                  Bone(
                    width: 65,
                    height: 24,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                  Bone(
                    width: 55,
                    height: 24,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                  Bone(
                    width: 60,
                    height: 24,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Price row
              Row(
                children: [Bone.text(words: 2), Spacer(), Bone.icon(size: 20)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
