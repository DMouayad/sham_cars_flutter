import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/utils/utils.dart';

class TrimListCard extends StatelessWidget {
  const TrimListCard({super.key, required this.trim, required this.onTap});

  final CarTrimSummary trim;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.cardRadius,
        side: BorderSide(color: cs.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumb
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 92,
                      height: 72,
                      child: _TrimImage(imageUrl: trim.imageUrl),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                trim.makeName.toUpperCase(),
                                style: tt.labelSmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (trim.isFeatured)
                              Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: cs.primary,
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trim.displayName,
                          style: tt.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (trim.yearDisplay?.isNotEmpty ?? false)
                          Text(
                            trim.yearDisplay!,
                            style: tt.labelSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _SpecsRow(trim: trim),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (trim.priceDisplay case final price?)
                    Text(
                      price,
                      style: tt.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  else
                    Text(
                      '—',
                      style: tt.labelLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  const Spacer(),
                  Icon(
                    context.isLTR ? Icons.chevron_left : Icons.chevron_right,
                    size: 20,
                    color: cs.outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrimImage extends StatelessWidget {
  const _TrimImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _Placeholder(cs: cs),
      );
    }
    return _Placeholder(cs: cs);
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.directions_car, size: 48, color: cs.outline),
      ),
    );
  }
}

class _SpecsRow extends StatelessWidget {
  const _SpecsRow({required this.trim});
  final CarTrimSummary trim;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        if (trim.range.isNotEmpty)
          _SpecChip(
            icon: Icons.route,
            text: trim.range.display,
            color: Colors.green,
          ),
        if (trim.acceleration.isNotEmpty)
          _SpecChip(
            icon: Icons.speed,
            text: trim.acceleration.display,
            color: Colors.orange,
          ),
        if (trim.batteryCapacity.isNotEmpty)
          _SpecChip(
            icon: Icons.battery_charging_full,
            text: trim.batteryCapacity.display,
            color: Colors.blue,
          ),
        if (trim.bodyType.isNotEmpty)
          _SpecChip(
            icon: Icons.directions_car_outlined,
            text: trim.bodyType,
            color: cs.primary,
          ),
      ],
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: ThemeConstants.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
