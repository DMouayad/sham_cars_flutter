import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

/// Compact card for horizontal lists (home screen)
class CompactModelCard extends StatelessWidget {
  const CompactModelCard({super.key, required this.model, required this.onTap});

  final CarModel model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: ThemeConstants.cardRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: ThemeConstants.cardRadius,
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image - takes most of the space
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(ThemeConstants.rCard),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: cs.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.directions_car,
                          size: 48,
                          color: cs.outline,
                        ),
                      ),
                    ),
                    // Make logo badge
                    if (model.make?.logoUrl case final url? when url.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: cs.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Image.network(
                            url,
                            width: 24,
                            height: 24,
                            errorBuilder: (_, _, _) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Info - compact
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand + Body type row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.makeName.toUpperCase(),
                            style: tt.labelSmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (model.bodyType case final bt?) ...[
                          const SizedBox(width: 4),
                          Text(bt.icon, style: const TextStyle(fontSize: 12)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Model name
                    Expanded(
                      child: Text(
                        model.name,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Country badge (if available)
                    if (model.make?.country case final country?
                        when country.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          country,
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
