import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class FeaturedTrimCard extends StatelessWidget {
  const FeaturedTrimCard({
    super.key,
    required this.trim,
    required this.onTap,
    this.width = 260,
  });

  final CarTrimSummary trim;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: ThemeConstants.cardRadius,
        child: Ink(
          decoration: BoxDecoration(
            // subtle gradient border feel
            gradient: LinearGradient(
              colors: [
                cs.primary.withOpacity(0.25),
                cs.secondary.withOpacity(0.18),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: ThemeConstants.cardRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.2),
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: ThemeConstants.cardRadius,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image header
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(ThemeConstants.rCard),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _TrimImage(imageUrl: trim.imageUrl),

                          // scrim
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.10),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.25),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Featured badge
                          PositionedDirectional(
                            top: 10,
                            start: 10,
                            child: _FeaturedBadge(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trim.makeName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.labelSmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trim.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),

                        SizedBox(
                          height: 25, // fixed chip row height
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              if (trim.range.isNotEmpty)
                                _MiniChip(
                                  icon: Icons.route,
                                  color: Colors.green,
                                  text: trim.range.display,
                                ),
                              if (trim.batteryCapacity.isNotEmpty)
                                _MiniChip(
                                  icon: Icons.battery_charging_full,
                                  color: Colors.blue,
                                  text: trim.batteryCapacity.display,
                                ),
                              if (trim.acceleration.isNotEmpty)
                                _MiniChip(
                                  icon: Icons.speed,
                                  color: Colors.orange,
                                  text: trim.acceleration.display,
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        Flexible(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  trim.priceDisplay ?? '—',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_left,
                                color: cs.outline,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
        errorBuilder: (_, __, ___) => _placeholder(cs),
      );
    }
    return _placeholder(cs);
  }

  Widget _placeholder(ColorScheme cs) {
    return Container(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.directions_car, size: 48, color: cs.outline),
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
          const SizedBox(width: 6),
          Text(
            'مميز', // localize later (recommended)
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
