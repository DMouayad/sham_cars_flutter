import 'package:flutter/material.dart';
import 'package:sham_cars/features/search/models/search_result.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/utils/utils.dart';

const _baseImagePath = 'assets/images/';

class SearchResultCardContent extends StatelessWidget {
  const SearchResultCardContent(
    this.result, {
    this.showLocationAndRating = true,
    super.key,
  });
  final SearchResult result;
  final bool showLocationAndRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Image.asset(
              _baseImagePath + result.avatarImgUrl,
              width: 45,
              height: 45,
              color:
                  context.isDarkMode &&
                      result.category == SearchResultCategory.facility
                  ? AppTheme.lightGreyColor
                  : null,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: context.myTxtTheme.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (result.subTitle.isNotEmpty) ...[
                  SizedBox(
                    width: 100,
                    child: Text(
                      result.subTitle,
                      overflow: TextOverflow.ellipsis,
                      style: context.myTxtTheme.bodySmall,
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                if (showLocationAndRating)
                  _LocationAndRatingTile(
                    result,
                    width: context.screenWidth - (140),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationAndRatingTile extends StatelessWidget {
  const _LocationAndRatingTile(this.result, {required this.width});

  final double width;
  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Icon(
            Icons.location_pin,
            color: context.colorScheme.primary,
            size: 18,
          ),
          SizedBox(
            width: width * .6,
            child: Text(
              result.location,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: context.myTxtTheme.bodySmall,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.star, color: AppTheme.yellowColor, size: 18),
              const SizedBox(width: 3),
              Text(
                result.stars.toStringAsPrecision(1),
                style: context.myTxtTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
