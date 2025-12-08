import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const kFontFamily = 'almarai';

  static const _darkColorScheme = ColorScheme.dark(
    primary: Color(0xFF4287D7),
    secondary: Color(0xFF9CD161),
    surface: Color(0xFF181818),
    onSurface: Color(0xFFD9D9D9),
  );

  static const _lightColorScheme = ColorScheme.light(
    primary: Color(0xFF2B75CA),
    secondary: Color(0xFF9CD161),
    surface: Color(0xFFFAFBFD),
    onSurface: Color(0xFF444444),
  );

  static final _filledButtonThemeData = FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  static final lightThemeData = ThemeData(
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: _lightColorScheme.surface,
    filledButtonTheme: _filledButtonThemeData,
    outlinedButtonTheme: _outlinedButtonThemeData(_lightColorScheme.primary),
    elevatedButtonTheme: _elevatedButtonTheme(),
    dividerColor: dividerColor,
  );

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  static final darkThemeData = ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    filledButtonTheme: _filledButtonThemeData,
    outlinedButtonTheme: _outlinedButtonThemeData(_darkColorScheme.primary),
    elevatedButtonTheme: _elevatedButtonTheme(),
    dividerColor: dividerColor,
  );

  static const redColor = Color(0xFFC92A22);
  static const lightGreyColor = Color(0xFFD9D9D9);
  static const dividerColor = Color(0xFF969696);
  static const secondaryTextColor = Color(0xFF8C8C8C);
  static const textFieldBorderColor = Color(0xFFD0D0D0);
  static const subTextColor = Color(0xFF9AA0BD);
  static const yellowColor = Color(0xFFF2C94C);
}
