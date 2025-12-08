import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/dialogs/confirmation_dialog.dart';

class NoPopWrapper extends StatelessWidget {
  const NoPopWrapper({
    super.key,
    required this.child,
    this.stayOnPageBtnLabel,
    this.goBackBtnLabel,
    this.dialogMessage,
    this.dialogTitle,
  });

  final Widget child;
  final String? stayOnPageBtnLabel;
  final String? goBackBtnLabel;
  final String? dialogMessage;
  final String? dialogTitle;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        final originalContext = context;
        showConfirmationDialog(
          context,
          content: dialogMessage,
          title: dialogTitle ?? context.l10n.popConfirmationDialogTitle,
          cancelBtnText: stayOnPageBtnLabel ?? context.l10n.stayOnPageBtnLabel,
          confirmBtnText: goBackBtnLabel ?? context.l10n.goBackBtnLabel,
        ).then((popConfirmed) {
          if (popConfirmed == true && originalContext.mounted) {
            originalContext.pop();
          }
        });
      },
      child: child,
    );
  }
}
