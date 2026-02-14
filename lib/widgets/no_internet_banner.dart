import 'package:flutter/material.dart';
import 'package:sham_cars/l10n/app_localizations.dart';
import 'package:sham_cars/utils/utils.dart';

class NoInternetBanner extends StatelessWidget {
  const NoInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Material(
      child: Container(
        width: double.infinity,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          l10n.noInternetConnection,
          style: context.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onErrorContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
