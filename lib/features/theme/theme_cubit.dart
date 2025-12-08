import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggleDarkMode() {
    if (state != ThemeMode.dark) {
      emit(ThemeMode.dark);
    }
  }

  void toggleLightMode() {
    if (state != ThemeMode.light) {
      emit(ThemeMode.light);
    }
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values.elementAt(json['theme_mode']);
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'theme_mode': state.index};
  }
}
