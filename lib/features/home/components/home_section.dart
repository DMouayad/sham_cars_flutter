import 'package:flutter/material.dart';
import 'package:sham_cars/utils/utils.dart';

class HomeScreenSection extends StatelessWidget {
  const HomeScreenSection({
    super.key,
    required this.title,
    this.onViewAll,
    required this.content,
  });

  final String title;
  final VoidCallback? onViewAll;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.myTxtTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onViewAll != null)
              TextButton(
                onPressed: onViewAll,
                child: Text(context.l10n.viewAllBtnLabel),
              ),
          ],
        ),
        const SizedBox(height: 15),
        content,
      ],
    );
  }
}
