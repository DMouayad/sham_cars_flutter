import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/widgets/pill_chip.dart';

class EnrichedModelCard extends StatelessWidget {
  const EnrichedModelCard({
    super.key,
    required this.model,
    required this.onTap,
  });

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
            // Image area with make logo overlay
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(ThemeConstants.rCard),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background
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

                    // Make logo (if available)
                    if (model.make?.logoUrl case final logoUrl?
                        when logoUrl.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: cs.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            logoUrl,
                            width: 32,
                            height: 32,
                            errorBuilder: (_, _, _) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.pSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    Text(
                      model.makeName.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        color: cs.primary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Model name
                    Text(
                      model.name,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Chips: body type, country
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (model.bodyType case final bt?)
                          PillChip(
                            text: bt.name,
                            icon: Text(
                              bt.icon,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        if (model.make?.country case final country?
                            when country.isNotEmpty)
                          PillChip(
                            text: country,
                            icon: const Icon(Icons.public, size: 12),
                          ),
                      ],
                    ),

                    // Action hint
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(
                        Icons.chevron_left,
                        size: 20,
                        color: cs.outline,
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
