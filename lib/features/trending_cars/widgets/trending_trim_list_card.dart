import 'package:flutter/material.dart';
import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/utils/utils.dart';

class TrendingTrimListCard extends StatelessWidget {
  const TrendingTrimListCard({
    super.key,
    required this.rank,
    required this.trim,
    required this.onTap,
  });

  final int rank;
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
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                context.isDarkMode
                    ? cs.primary.withValues(alpha: .08)
                    : cs.secondary.withValues(alpha: .20),
                cs.surface,
              ],
            ),
          ),
          child: Container(
            constraints: BoxConstraints(minHeight: 160),
            padding: const EdgeInsets.all(12),
            child: Column(
              spacing: 6,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ThumbWithRank(rank: rank, imageUrl: trim.imageUrl),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Make + rating pill (top line)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  trim.makeName.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.labelSmall?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              if (_hasRating(trim)) ...[
                                const SizedBox(width: 8),
                                _RatingPill(
                                  rating: trim.avgRating!,
                                  count: trim.reviewsCount!,
                                ),
                              ],
                              if (trim.isFeatured) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.star_rounded,
                                  size: 18,
                                  color: cs.primary,
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Model
                          Text(
                            trim.displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                            ),
                          ),

                          const SizedBox(height: 6),

                          //  meta
                          Text(
                            _metaLine(trim),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tt.labelMedium?.copyWith(
                              color: cs.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Specs row (premium pills, stable height)
                          SizedBox(
                            height: 30,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _specPills(context, trim),
                            ),
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trim.priceDisplay ?? '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),

                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: cs.secondary.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static bool _hasRating(CarTrimSummary t) =>
      t.avgRating != null && (t.reviewsCount ?? 0) > 0;

  static String _metaLine(CarTrimSummary t) {
    final parts = <String>[];
    if (t.bodyType.isNotEmpty) parts.add(t.bodyType);
    if (t.yearDisplay?.isNotEmpty ?? false) parts.add(t.yearDisplay!);
    return parts.join(' • ');
  }

  static List<Widget> _specPills(BuildContext context, CarTrimSummary t) {
    final out = <Widget>[];

    void add(Widget w) {
      if (out.isNotEmpty) out.add(const SizedBox(width: 8));
      out.add(w);
    }

    // Keep it premium and not too busy: prefer 2–3 key specs max
    if (t.range.isNotEmpty) {
      add(
        _SpecPill(icon: Icons.route, text: t.range.display, tint: Colors.green),
      );
    }
    if (t.batteryCapacity.isNotEmpty) {
      add(
        _SpecPill(
          icon: Icons.battery_charging_full,
          text: t.batteryCapacity.display,
          tint: Colors.blue,
        ),
      );
    }
    if (t.acceleration.isNotEmpty && out.length < 5) {
      add(
        _SpecPill(
          icon: Icons.speed,
          text: t.acceleration.display,
          tint: Colors.orange,
        ),
      );
    }

    // fallback if no specs
    if (out.isEmpty) {
      add(
        _SpecPill(
          icon: Icons.info_outline_rounded,
          text: (t.bodyType.isNotEmpty) ? t.bodyType : '—',
          tint: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return out;
  }
}

class _ThumbWithRank extends StatelessWidget {
  const _ThumbWithRank({required this.rank, required this.imageUrl});

  final int rank;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 112,
        height: 112,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _TrimImage(imageUrl: imageUrl),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: 10,
              top: 10,
              child: _RankBadge(rank: rank),
            ),
            PositionedDirectional(
              end: 10,
              bottom: 10,
              child: Icon(
                Icons.trending_up_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
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
        color: Colors.black.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
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

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating, required this.count});
  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 6, 8, 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            '${rating.toStringAsFixed(1)} ($count)',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w900,
              fontSize: 12,
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
        child: Icon(Icons.directions_car, size: 44, color: cs.outline),
      ),
    );
  }
}

class _SpecPill extends StatelessWidget {
  const _SpecPill({required this.icon, required this.text, required this.tint});

  final IconData icon;
  final String text;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 12, 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
        // border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: tint),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
