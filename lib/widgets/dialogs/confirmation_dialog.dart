import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sham_cars/utils/utils.dart';

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  String? content,
  String? confirmBtnText,
  String? cancelBtnText,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return ConfirmationDialog(
        title: title,
        content: content,
        confirmBtnText: confirmBtnText,
        cancelBtnText: cancelBtnText,
      );
    },
  );
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    this.content,
    this.confirmBtnText,
    this.cancelBtnText,
  });
  final String title;
  final String? content;
  final String? confirmBtnText;
  final String? cancelBtnText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: context.platformBorderRadius),
      title: Text(title),
      content: content != null ? Text(content!) : null,
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(cancelBtnText ?? context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(
            confirmBtnText ?? context.l10n.ok,
            style: TextStyle(color: context.colorScheme.error),
          ),
        ),
      ],
    );
  }
}
