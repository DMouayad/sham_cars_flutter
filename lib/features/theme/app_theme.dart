import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class AppTheme {
  /// ---------------------------------------------------------------------------
  /// 1️⃣  Color constants (hex)
  /// ---------------------------------------------------------------------------

  static const corporateColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary
    primary: CorporateColors.primary,
    onPrimary: CorporateColors.primaryContent,
    primaryContainer:
        CorporateColors.primary, // Corporate style often keeps high contrast
    onPrimaryContainer: CorporateColors.primaryContent,

    // Secondary
    secondary: CorporateColors.secondary,
    onSecondary: CorporateColors.secondaryContent,
    secondaryContainer: CorporateColors.secondary,
    onSecondaryContainer: CorporateColors.secondaryContent,

    // Tertiary (Accent)
    tertiary: CorporateColors.accent,
    onTertiary: CorporateColors.accentContent,
    tertiaryContainer: CorporateColors.accent,
    onTertiaryContainer: CorporateColors.accentContent,

    // Error
    error: CorporateColors.error,
    onError: CorporateColors.errorContent,

    // Backgrounds
    surface: CorporateColors.base100,
    onSurface: CorporateColors.baseContent,

    // Containers
    surfaceContainer: CorporateColors.base200,
    surfaceContainerHigh: CorporateColors.base300,

    // Neutral
    inverseSurface: CorporateColors.neutral,
    onInverseSurface: CorporateColors.neutralContent,

    // Outline (Subtle border using base content)
    outline: Color(0x332B3440),
    outlineVariant: CorporateColors.base300,
  );

  static final ThemeData corporateTheme = ThemeData(
    useMaterial3: true,
    colorScheme: corporateColorScheme,
    scaffoldBackgroundColor: CorporateColors.base100, // Crisp white background
    // Custom Color Extension
    extensions: <ThemeExtension<dynamic>>[DaisyCustomColors.corporate],

    // --radius-box: 0.25rem -> 4px
    cardTheme: CardThemeData(
      color: CorporateColors.base100,
      surfaceTintColor: Colors.transparent, // Remove M3 tint to keep it crisp
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: const BorderSide(
          color: CorporateColors.base200,
          width: 1,
        ), // Optional: Corporate look often has borders
      ),
      elevation: 0, // "Corporate" flat look (depth: 0 in CSS)
    ),

    // --radius-field: 0.25rem -> 4px
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CorporateColors.base100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: CorporateColors.base300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: CorporateColors.base300),
      ),
    ),

    // --radius-selector: 0.25rem -> 4px
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        backgroundColor: CorporateColors.primary,
        foregroundColor: CorporateColors.primaryContent,
        elevation: 0,
      ),
    ),
  );
  // Light mode

  static final _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF0A3D62),
    primaryContainer: const Color(0xFF004E9A),
    onPrimary: const Color(0xFFFFFFFF),
    secondary: const Color(0xFF4A4A4A),
    secondaryContainer: const Color(0xFF2E2E2E),
    onSecondary: const Color(0xFFFFFFFF),
    tertiary: const Color(0xFFFF6F00),
    tertiaryContainer: const Color(0xFFFF9E2C),
    onTertiary: const Color(0xFFFFFFFF),
    error: const Color(0xFFB00020),
    errorContainer: const Color(0xFFFDEDEC),
    onError: const Color(0xFFFFFFFF),
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF000000),
    surfaceContainerHighest: const Color(0xFFF5F5F5),
    onSurfaceVariant: const Color(0xFF333333),
    outline: const Color(0xFFD3D3D3),
    outlineVariant: const Color(0xFFBDBDBD),
    inverseSurface: const Color(0xFF121212),
    onInverseSurface: const Color(0xFFFFFFFF),
    scrim: const Color(0xFF000000),
  );

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary – now Dodger Blue
    primary: Color(0xFF1E90FF), // Dodger Blue
    primaryContainer: Color(0xFF004E9A), // Keep the same container (dark navy)
    onPrimary: Color(0xFF000000), // Black text on primary
    // Secondary
    secondary: Color(0xFFB0B0B0), // Light gray
    secondaryContainer: Color(0xFF4A4A4A), // Darker container
    onSecondary: Color(0xFF000000), // Text/icons on secondary
    // Tertiary
    tertiary: Color(0xFFFF9E2C), // Lighter orange
    tertiaryContainer: Color(0xFFFF6F00), // Darker orange
    onTertiary: Color(0xFF000000), // Text/icons on tertiary
    // Error
    error: Color(0xFFCF6679), // Lighter error
    errorContainer: Color(0xFFB00020), // Darker error background
    onError: Color(0xFFFFFFFF), // Text/icons on error
    // Background / Surface
    surface: Color(0xFF1E1E1E), // Card / modal background
    onSurface: Color(0xFFFFFFFF), // Text on surfaces
    surfaceContainerHighest: Color(0xFF2E2E2E), // Slightly darker surface
    onSurfaceVariant: Color(0xFFE0E0E0), // Text on surface variant
    // Outline / Scrim
    outline: Color(0xFF4A4A4A), // Borders, dividers
    outlineVariant: Color(0xFF6E6E6E), // Variant borders
    scrim: Color(0xFF000000),
    // Inverse (for high‑contrast elements)
    inverseSurface: Color(0xFFFFFFFF), // Light background
    onInverseSurface: Color(0xFF000000), // Text on inverse surface
  );

  static final _filledButtonThemeData = FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
  static OutlinedButtonThemeData _outlinedButtonThemeData(Color primary) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(primary),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(color: primary),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      );

  static final _inputDecorationTheme = InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );

  static final lightThemeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: _lightColorScheme.surface,
    filledButtonTheme: _filledButtonThemeData,
    outlinedButtonTheme: _outlinedButtonThemeData(_lightColorScheme.primary),
    elevatedButtonTheme: _elevatedButtonTheme(),
    inputDecorationTheme: _inputDecorationTheme,
    dividerColor: dividerColor,
  );

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }

  static final darkThemeData = ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    filledButtonTheme: _filledButtonThemeData,
    outlinedButtonTheme: _outlinedButtonThemeData(_darkColorScheme.primary),
    elevatedButtonTheme: _elevatedButtonTheme(),
    inputDecorationTheme: _inputDecorationTheme,
    dividerColor: dividerColor,
  );

  static TextTheme applyLetterSpacing(
    TextTheme textTheme,
    double letterSpacing,
  ) {
    return textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        letterSpacing: letterSpacing,
      ),
      displayMedium: textTheme.displayMedium?.copyWith(
        letterSpacing: letterSpacing,
      ),
      displaySmall: textTheme.displaySmall?.copyWith(
        letterSpacing: letterSpacing,
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        letterSpacing: letterSpacing,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        letterSpacing: letterSpacing,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        letterSpacing: letterSpacing,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(letterSpacing: letterSpacing),
      titleMedium: textTheme.titleMedium?.copyWith(
        letterSpacing: letterSpacing,
      ),
      titleSmall: textTheme.titleSmall?.copyWith(letterSpacing: letterSpacing),
      bodyLarge: textTheme.bodyLarge?.copyWith(letterSpacing: letterSpacing),
      bodyMedium: textTheme.bodyMedium?.copyWith(letterSpacing: letterSpacing),
      bodySmall: textTheme.bodySmall?.copyWith(letterSpacing: letterSpacing),
      labelLarge: textTheme.labelLarge?.copyWith(letterSpacing: letterSpacing),
      labelMedium: textTheme.labelMedium?.copyWith(
        letterSpacing: letterSpacing,
      ),
      labelSmall: textTheme.labelSmall?.copyWith(letterSpacing: letterSpacing),
    );
  }

  static const redColor = Color(0xFFC92A22);
  static const lightGreyColor = Color(0xFFD9D9D9);
  static const dividerColor = Color(0xFFD3D3D3);
  static const secondaryTextColor = Color(0xFF777777);
  static const subTextColor = Color(0xFF9AA0BD);
  static const yellowColor = Color(0xFFF2C94C);

  static const borderRadius = 8.0;
}
