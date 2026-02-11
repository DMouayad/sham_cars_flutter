import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/widgets/rating_pill.dart';

class TrendingDeckCard extends StatelessWidget {
  const TrendingDeckCard({
    super.key,
    required this.trim,
    required this.rank,
    required this.onTap,
    required this.height,
    required this.inHome,
    this.width,
  });

  final CarTrimSummary trim;
  final int rank;
  final VoidCallback onTap;
  final double height;
  final double? width;
  final bool inHome;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeConstants.cardRadius,
          side: BorderSide(color: cs.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _TrimImage(imageUrl: trim.imageUrl),

              // Dark gradient for readability
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.60),
                      ],
                    ),
                  ),
                ),
              ),

              // Rank badge
              PositionedDirectional(
                start: 12,
                top: 12,
                child: _RankBadge(rank: rank),
              ),
              if (trim.avgRating != null && (trim.reviewsCount ?? 0) > 0)
                PositionedDirectional(
                  end: 12,
                  top: 12,
                  child: RatingPill(
                    rating: trim.avgRating!,
                    count: trim.reviewsCount!,
                  ),
                ),

              // Bottom overlay content
              PositionedDirectional(
                start: 0,
                end: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.50),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          trim.makeName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          trim.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: (inHome ? tt.titleMedium : tt.titleLarge)
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),

                        // Meta row (body type + years) — uses fields you already have
                        Text(
                          _metaText(trim),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.80),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Spec chips (limited set for clarity)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (trim.range.isNotEmpty)
                              _GlassChip(
                                icon: Icons.route,
                                label: trim.range.display,
                              ),
                            if (trim.batteryCapacity.isNotEmpty)
                              _GlassChip(
                                icon: Icons.battery_charging_full,
                                label: trim.batteryCapacity.display,
                              ),
                            if (trim.acceleration.isNotEmpty)
                              _GlassChip(
                                icon: Icons.speed,
                                label: trim.acceleration.display,
                              ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                trim.priceDisplay ?? '—',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: (inHome ? tt.bodySmall : tt.titleMedium)
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white.withValues(alpha: 0.85),
                              size: 22,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _metaText(CarTrimSummary trim) {
    final parts = <String>[];
    if (trim.bodyType.isNotEmpty) parts.add(trim.bodyType);
    if (trim.yearStart != null) {
      final end = trim.yearEnd;
      parts.add(end != null ? '${trim.yearStart}–$end' : '${trim.yearStart}');
    }
    return parts.isEmpty ? '—' : parts.join(' • ');
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        '#$rank',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.90)),
          const SizedBox(width: 6),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.90),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
        child: Icon(Icons.directions_car, size: 56, color: cs.outline),
      ),
    );
  }
}
