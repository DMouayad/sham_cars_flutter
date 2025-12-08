import 'package:flutter/material.dart';
import 'package:sham_cars/features/search/models/search_result.dart';
import 'package:sham_cars/features/search/widgets/search_result_card.dart';
import 'package:sham_cars/utils/utils.dart';

class SearchCardWrapper extends StatelessWidget {
  const SearchCardWrapper({
    super.key,
    required this.onTap,
    required this.result,
  });
  final SearchResult result;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.colorScheme.secondaryContainer.withOpacity(.03),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: SearchResultCardContent(result),
      ),
    );
  }
}
