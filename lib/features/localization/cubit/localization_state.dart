part of 'localization_cubit.dart';

class LocalizationState {
  const LocalizationState(this.locale);
  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  @override

  bool operator ==(Object other) {
    return other is LocalizationState &&
        locale.languageCode == other.locale.languageCode;
  }

  @override
  int get hashCode => locale.hashCode;
}
