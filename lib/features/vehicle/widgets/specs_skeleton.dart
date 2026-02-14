import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sham_cars/features/theme/constants.dart';

class GroupedSpecsSkeleton extends StatelessWidget {
  const GroupedSpecsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Skeletonizer(
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: ThemeConstants.cardRadius,
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          children: List.generate(4, (groupIndex) {
            return Column(
              children: [
                // Simulates the ExpansionTile header
                ListTile(
                  leading: const Icon(Icons.circle),
                  title: Text(
                    BoneMock.words(2),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  trailing: const Icon(Icons.expand_more),
                ),

                // Simulates expanded children (show for first 2 groups)
                if (groupIndex < 2)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      0,
                      16,
                      12,
                    ),
                    child: Column(
                      children: List.generate(
                        3,
                        (_) => const _SpecRowSkeleton(),
                      ),
                    ),
                  ),

                // Divider between groups (except last)
                if (groupIndex < 3)
                  Divider(height: 1, color: cs.outlineVariant),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _SpecRowSkeleton extends StatelessWidget {
  const _SpecRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(BoneMock.words(2))),
          const SizedBox(width: 12),
          Text(
            BoneMock.words(1),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
