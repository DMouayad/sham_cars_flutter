import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sham_cars/utils/utils.dart';

Future<void> showSuccessDialog(
  BuildContext context, {
  required String title,
  String? content,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return SuccessDialog(title: title, content: content);
    },
  );
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key, this.content, required this.title});

  final String title;
  final String? content;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: context.platformBorderRadius),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(
            Icons.check_circle_outline,
            size: 30,
            color: context.colorScheme.primary,
          ),
        ],
      ),
      content: content != null ? Text(content!) : null,
      actions: [
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(context.l10n.ok),
        ),
      ],
    );
  }
}
