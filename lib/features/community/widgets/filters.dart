import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';

import '../models.dart';

class CommunityFilters extends StatelessWidget {
  const CommunityFilters({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.questionsCount,
    required this.reviewsCount,
  });

  final CommunityFilter selected;
  final ValueChanged<CommunityFilter> onChanged;
  final int questionsCount;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.p),
      child: Row(
        children: [
          _FilterChip(
            label: 'الكل',
            count: questionsCount + reviewsCount,
            isSelected: selected == CommunityFilter.all,
            onTap: () => onChanged(CommunityFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'الأسئلة',
            icon: Icons.forum_outlined,
            count: questionsCount,
            isSelected: selected == CommunityFilter.questions,
            onTap: () => onChanged(CommunityFilter.questions),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'التجارب',
            icon: Icons.rate_review_outlined,
            count: reviewsCount,
            isSelected: selected == CommunityFilter.reviews,
            onTap: () => onChanged(CommunityFilter.reviews),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.icon,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? cs.primaryContainer : cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? cs.onPrimaryContainer
                      : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? cs.onPrimaryContainer
                      : cs.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.onPrimaryContainer.withOpacity(0.15)
                      : cs.outline.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? cs.onPrimaryContainer
                        : cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
