import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/widgets/rating_pill.dart';

class TrimCarouselCard extends StatelessWidget {
  const TrimCarouselCard({
    super.key,
    required this.trim,
    required this.onTap,
    this.width = 220,
    this.height = 280,
  });

  final CarTrimSummary trim;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final imageHeight = width * (10 / 16);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
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
                // ── Image with overlays ──
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _TrimImage(imageUrl: trim.imageUrl),

                      // Subtle gradient for badges readability
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Rating pill (top-right)
                      if (trim.avgRating != null &&
                          (trim.reviewsCount ?? 0) > 0)
                        PositionedDirectional(
                          end: 8,
                          top: 8,
                          child: RatingPill(
                            rating: trim.avgRating!,
                            count: trim.reviewsCount!,
                          ),
                        ),

                      // Year badge (bottom-right)
                      if (trim.yearStart != null)
                        PositionedDirectional(
                          end: 8,
                          bottom: 8,
                          child: _OverlayBadge(text: _yearText(trim)),
                        ),
                    ],
                  ),
                ),

                // ── Content ──
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Make name
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
                        const SizedBox(height: 2),

                        // Display name
                        Text(
                          trim.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Spec chips row
                        SizedBox(
                          height: 25,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              if (trim.range.isNotEmpty) ...[
                                _MiniChip(
                                  icon: Icons.route,
                                  color: Colors.green,
                                  text: trim.range.display,
                                ),
                                const SizedBox(width: 6),
                              ],
                              if (trim.batteryCapacity.isNotEmpty) ...[
                                _MiniChip(
                                  icon: Icons.battery_charging_full,
                                  color: Colors.blue,
                                  text: trim.batteryCapacity.display,
                                ),
                                const SizedBox(width: 6),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _yearText(CarTrimSummary trim) {
    if (trim.yearStart == null) return '';
    final end = trim.yearEnd;
    return end != null ? '${trim.yearStart}–$end' : '${trim.yearStart}';
  }
}

// ── Overlay badge on image ──
class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Image ──
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
        child: Icon(Icons.directions_car, size: 42, color: cs.outline),
      ),
    );
  }
}

// ── Mini chip ──
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
      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
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
