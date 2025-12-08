import 'package:flutter/material.dart';

import 'package:sham_cars/l10n/app_localizations.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'localization_state.dart';

const kDefaultLocale = Locale('ar');
const _kLangCodeStorageKey = 'langCode';

class LocalizationCubit extends HydratedCubit<LocalizationState> {
  LocalizationCubit() : super(const LocalizationState(kDefaultLocale));
  void setLocale(Locale locale) {
    if (state.locale != locale) {
      emit(LocalizationState(locale));
    }
  }

  void switchLocale() {
    final newLocale = state.locale.languageCode.toLowerCase() == 'en'
        ? 'ar'
        : 'en';
    setLocale(Locale(newLocale));
  }

  @override
  LocalizationState? fromJson(Map<String, dynamic> json) {
    if (json case {
      _kLangCodeStorageKey: String langCode,
    } when _langCodeIsSupported(langCode)) {
      return LocalizationState(Locale(langCode));
    }
    return null;
  }

  bool _langCodeIsSupported(String code) {
    return AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == code,
    );
  }

  @override
  Map<String, dynamic>? toJson(LocalizationState state) {
    return {_kLangCodeStorageKey: state.locale.languageCode};
  }
}
