import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sham_cars/l10n/app_localizations.dart';
import 'package:sham_cars/routes/router.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/routes/routes.dart';

import 'features/auth/cubit/auth_state_cubit.dart';
import 'features/auth/models/auth_state.dart';
import 'features/localization/cubit/localization_cubit.dart';
import 'features/theme/theme_cubit.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (_) => ThemeCubit()),
        BlocProvider(lazy: false, create: (_) => LocalizationCubit()),
        BlocProvider(lazy: false, create: (_) => AuthStateCubit()),
      ],
      child: BlocListener<AuthStateCubit, AuthState>(
        // This listener is added to redirect user to home screen when
        // `AuthState` is at an unventilated state
        listener: (context, state) =>
            router.go(const HomeScreenRoute().location),
        listenWhen: (prev, current) => current.isUnauthenticated(),
        child: const MainAppView(),
      ),
    );
  }
}

class MainAppView extends StatelessWidget {
  const MainAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LocalizationCubit, LocalizationState>(
          builder: (context, localeState) {
            return MaterialApp.router(
              title: 'Healing Guide',
              routerConfig: router,
              themeMode: themeMode,
              locale: localeState.locale,
              theme: AppTheme.lightThemeData.copyWith(
                textTheme: localeState.isArabic
                    ? AppTheme.lightThemeData.textTheme.apply(
                        fontFamily: 'almarai',
                      )
                    : GoogleFonts.poppinsTextTheme(),
              ),
              darkTheme: AppTheme.darkThemeData.copyWith(
                textTheme: localeState.isArabic
                    ? AppTheme.darkThemeData.textTheme.apply(
                        fontFamily: 'almarai',
                      )
                    : GoogleFonts.poppinsTextTheme(),
              ),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        );
      },
    );
  }
}
