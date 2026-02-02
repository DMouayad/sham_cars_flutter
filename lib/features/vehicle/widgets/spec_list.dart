// lib/features/vehicle/widgets/expandable_specs_list.dart
import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/spec_icons.dart';

class ExpandableSpecsList extends StatefulWidget {
  const ExpandableSpecsList({
    super.key,
    required this.specs,
    this.initialVisibleCount = 5,
  });

  final Map<String, String> specs;
  final int initialVisibleCount;

  @override
  State<ExpandableSpecsList> createState() => _ExpandableSpecsListState();
}

class _ExpandableSpecsListState extends State<ExpandableSpecsList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (widget.specs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: ThemeConstants.cardRadius,
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 32, color: cs.outline),
              const SizedBox(height: 8),
              Text(
                'لا توجد مواصفات متاحة',
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final entries = widget.specs.entries.toList();
    final showExpand = entries.length > widget.initialVisibleCount;
    final visibleEntries = _isExpanded
        ? entries
        : entries.take(widget.initialVisibleCount).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: ThemeConstants.cardRadius,
      ),
      child: Column(
        children: [
          // Specs
          ...visibleEntries.asMap().entries.map((e) {
            final index = e.key;
            final entry = e.value;
            final isLast = index == visibleEntries.length - 1 && !showExpand;

            return _SpecRow(
              label: entry.key,
              value: entry.value,
              showDivider: !isLast,
            );
          }),

          // Expand/Collapse button
          if (showExpand)
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(ThemeConstants.rCard),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded
                          ? 'عرض أقل'
                          : 'عرض الكل (${entries.length - widget.initialVisibleCount}+)',
                      style: tt.labelMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.label,
    required this.value,
    required this.showDivider,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final icon = SpecIcons.forKey(label);
    final iconColor = SpecIcons.colorFor(label, cs);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: cs.outlineVariant))
            : null,
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),

          // Label
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),

          // Value
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
