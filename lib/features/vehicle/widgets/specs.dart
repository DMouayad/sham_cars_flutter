import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/utils.dart';
import 'spec_groups.dart';

class GroupedSpecs extends StatelessWidget {
  const GroupedSpecs({super.key, required this.specs});
  final Map<String, String> specs;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final groups = groupSpecs(context.l10n, specs);
    if (groups.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: ThemeConstants.cardRadius,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          for (final g in groups)
            ExpansionTile(
              leading: Icon(g.icon, color: cs.primary),
              title: Text(
                g.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              childrenPadding: const EdgeInsetsDirectional.fromSTEB(
                16,
                0,
                16,
                12,
              ),
              children: [for (final item in g.items) _SpecRow(item: item)],
            ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.item});
  final SpecItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(item.icon, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(child: Text(item.label)),
          const SizedBox(width: 12),
          Text(item.value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
