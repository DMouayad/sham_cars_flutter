import 'package:flutter/widgets.dart';
import 'package:sham_cars/utils/utils.dart';

class CityText {
  static String label(BuildContext context, String code) {
    final l10n = context.l10n;
    return switch (code) {
      'damascus' => l10n.cityDamascus,
      'aleppo' => l10n.cityAleppo,
      'homs' => l10n.cityHoms,
      'hama' => l10n.cityHama,
      'latakia' => l10n.cityLatakia,
      'tartus' => l10n.cityTartus,
      _ => code,
    };
  }
}
