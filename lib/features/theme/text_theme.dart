import 'package:flutter/material.dart';
import 'package:sham_cars/utils/utils.dart';

import 'app_theme.dart';

class MyTextTheme {
  final BuildContext context;

  factory MyTextTheme.of(BuildContext context) {
    return MyTextTheme._(context);
  }

  MyTextTheme._(this.context);

  TextStyle get displayLarge => TextStyle(
    fontSize: context.textTheme.displayLarge?.fontSize,
    color: context.colorScheme.onSurface,
  );

  TextStyle get displayMedium => TextStyle(
    fontSize: context.textTheme.displayMedium?.fontSize,
    color: context.colorScheme.onSurface,
  );

  TextStyle get displaySmall => TextStyle(
    fontSize: context.textTheme.displaySmall?.fontSize,
    color: context.colorScheme.onSurface,
  );

  TextStyle get titleLarge => TextStyle(
    fontSize: context.textTheme.titleLarge?.fontSize,
    color: context.colorScheme.onSurface,
    fontWeight: FontWeight.w600,
  );

  TextStyle get titleMedium => TextStyle(
    fontSize: context.textTheme.titleMedium?.fontSize,
    color: context.colorScheme.onSurface,
    fontWeight: FontWeight.w600,
  );

  TextStyle get titleSmall => TextStyle(
    fontSize: context.textTheme.titleSmall?.fontSize,
    color: context.colorScheme.onSurface,
  );

  TextStyle get bodyLarge => TextStyle(
    fontSize: context.textTheme.bodyLarge?.fontSize,
    color: context.colorScheme.onSurface,
  );

  TextStyle get bodyMedium => TextStyle(
    fontSize: context.textTheme.bodyMedium?.fontSize,
    color: context.colorScheme.onSurface,
  );

  TextStyle get bodySmall => TextStyle(
    fontSize: context.textTheme.bodySmall?.fontSize,
    color: AppTheme.secondaryTextColor,
    fontFamily: AppTheme.kFontFamily,
  );
}
