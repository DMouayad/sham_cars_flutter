import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class TrimCarouselCard extends StatelessWidget {
  const TrimCarouselCard({
    super.key,
    required this.trim,
    required this.onTap,
    this.width = 210,
    this.height = 240,
  });

  final CarTrimSummary trim;
  final VoidCallback onTap;
  final double width;
  final double height;

  static const double chipsRowHeight = 34;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // 16/10 image height
    final imageHeight = width * (10 / 16);

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.cardRadius,
          side: BorderSide(color: cs.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: _TrimImage(imageUrl: trim.imageUrl),
              ),

              // Content takes remaining space and cannot overflow
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trim.makeName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.labelSmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        trim.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const Spacer(),

                      SizedBox(
                        height: chipsRowHeight,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (trim.range.isNotEmpty) ...[
                              _MiniChip(
                                icon: Icons.route,
                                color: Colors.green,
                                text: trim.range.display,
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (trim.batteryCapacity.isNotEmpty)
                              _MiniChip(
                                icon: Icons.battery_charging_full,
                                color: Colors.blue,
                                text: trim.batteryCapacity.display,
                              ),
                          ],
                        ),
                      ),
                    ],
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
        errorBuilder: (_, _, _) => _placeholder(cs),
      );
    }
    return _placeholder(cs);
  }

  Widget _placeholder(ColorScheme cs) {
    return Container(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.directions_car, size: 42, color: cs.outline),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
