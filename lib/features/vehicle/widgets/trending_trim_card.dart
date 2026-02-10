import 'package:flutter/material.dart';

import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class TrendingTrimCard extends StatelessWidget {
  const TrendingTrimCard({
    super.key,
    required this.height,
    required this.trim,
    required this.onTap,
    this.width = 260,
    this.showMetaRow = false,
  });

  final CarTrimSummary trim;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool showMetaRow;

  static const double _chipRowHeight = 34; // ✅ enough for chip padding + text

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Stable image height based on width and 16/10 aspect ratio
    final imageHeight = width * (10 / 16);

    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onTap,
        borderRadius: ThemeConstants.cardRadius,
        child: Ink(
          decoration: BoxDecoration(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image header (fixed height, no aspect surprises)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(ThemeConstants.rCard),
                    ),
                    child: SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _TrimImage(imageUrl: trim.imageUrl),

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
                        ],
                      ),
                    ),
                  ),

                  // Content area takes remaining height and stays stable
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
                          if (showMetaRow) ...[
                            const SizedBox(height: 6),
                            Text(
                              [
                                    if (trim.bodyType.isNotEmpty) trim.bodyType,
                                    if (trim.yearStart != null)
                                      '${trim.yearStart}${trim.yearEnd != null ? '–${trim.yearEnd}' : ''}',
                                  ]
                                  .where((e) => e.toString().trim().isNotEmpty)
                                  .join(' • '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],

                          const Spacer(),

                          // Chips row: fixed height, horizontal scroll, with spacing
                          SizedBox(
                            height: _chipRowHeight,
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
                                if (trim.batteryCapacity.isNotEmpty) ...[
                                  _MiniChip(
                                    icon: Icons.battery_charging_full,
                                    color: Colors.blue,
                                    text: trim.batteryCapacity.display,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                if (trim.acceleration.isNotEmpty)
                                  _MiniChip(
                                    icon: Icons.speed,
                                    color: Colors.orange,
                                    text: trim.acceleration.display,
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Price row: overflow-safe
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  trim.priceDisplay ?? '—',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                trailingChevron(context),
                                color: cs.outline,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
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

  IconData trailingChevron(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded;
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
        errorBuilder: (context, error, stackTrace) => _placeholder(cs),
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
