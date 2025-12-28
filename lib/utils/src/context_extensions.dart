part of '../utils.dart';

extension ResponsiveValuesExtension on BuildContext {
  double get dialogWidth => min(560, screenWidth * .8);

  double get horizontalMargins {
    final screenWidth = MediaQuery.of(this).size.width;
    if (screenWidth <= 600) {
      return 16.0;
    } else if (screenWidth > 600 && screenWidth < 900) {
      return 26.0;
    } else if (screenWidth > 900 && screenWidth < 1200) {
      return 34.0;
    } else if (screenWidth >= 1200) {
      return screenWidth * 0.04;
    }
    return 12.0;
  }
}

extension ContextScreenExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenHeight => screenSize.height;

  double get screenWidth => screenSize.width;

  Orientation get orientation => mediaQuery.orientation;

  bool get isPortraitMode => orientation == Orientation.portrait;

  bool get isLandscapeMode => orientation == Orientation.landscape;

  bool get isMobile => (isLandscapeMode ? screenHeight : screenWidth) < 600;

  bool get isLandscapeMobile => (isLandscapeMode && isMobile);

  bool get isLandScapeTablet =>
      isLandscapeMode && (screenHeight >= 600 && screenHeight < 980);

  bool get isPortraitTablet =>
      isPortraitMode && (screenWidth >= 600 && screenWidth < 980);

  bool get isTablet => isLandScapeTablet || isPortraitTablet;

  bool get isDesktop => screenWidth >= 980;
}

extension ContextThemeExtension on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  ThemeData get theme => Theme.of(this);

  bool get isDarkMode => (theme.brightness == Brightness.dark);

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;
  MyTextTheme get myTxtTheme => MyTextTheme.of(this);

  BorderRadius get platformBorderRadius =>
      BorderRadius.circular(isAndroid ? 20 : 8);

  String getThemeModeName(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.light => l10n.lightThemeMode,
      ThemeMode.dark => l10n.darkThemeMode,
      ThemeMode.system => l10n.systemThemeMode,
    };
  }
}

extension ContextPlatformExtension on BuildContext {
  bool get isIos => platform == TargetPlatform.iOS;

  bool get isMacOs => platform == TargetPlatform.macOS;

  bool get isDesktopPlatform {
    return platform == TargetPlatform.windows ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.linux;
  }

  bool get isWindows =>
      platform == TargetPlatform.windows && Platform.isWindows;

  bool get isAndroid => platform == TargetPlatform.android;

  bool get isMobilePlatform =>
      platform == TargetPlatform.iOS || platform == TargetPlatform.android;

  TargetPlatform get platform => Theme.of(this).platform;
}

extension ContextLocaleExtension on BuildContext {
  bool get isArabicLocale => Localizations.localeOf(this).languageCode == 'ar';

  bool get isEnglishLocale => Localizations.localeOf(this).languageCode == 'en';

  bool get isRTL => isArabicLocale;

  bool get isLTR => isEnglishLocale;

  TextDirection get textDirection =>
      isLTR ? TextDirection.ltr : TextDirection.rtl;

  Locale get locale => Localizations.localeOf(this);

  AppLocalizations get l10n => AppLocalizations.of(this);

  String getLocaleFullName(String languageCode) {
    return switch (languageCode) {
      'en' => 'English',
      'ar' => 'العربية',
      _ => '',
    };
  }
}

enum DeviceType { mobile, tablet, desktop }
