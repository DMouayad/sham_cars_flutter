import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/search/cubit/search_cubit.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/features/localization/cubit/localization_cubit.dart';
import 'package:sham_cars/features/theme/theme_cubit.dart';
import 'package:sham_cars/l10n/app_localizations.dart';
import 'package:sham_cars/router/redirect_helper.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/page_loader.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => GoRouter(
        routes: $appRoutes,
        initialLocation: const HomeRoute().location,
        debugLogDiagnostics: true,
        refreshListenable: GetIt.I.get<AuthNotifier>(),
        redirect: redirectHelper,
      ),
      lazy: false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(lazy: false, create: (_) => ThemeCubit()),
          BlocProvider(lazy: false, create: (_) => LocalizationCubit()),
          BlocProvider(create: (_) => SearchCubit()),
        ],
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
              title: 'Sham Cars',
              routerConfig: context.read<GoRouter>(),
              themeMode: themeMode,
              locale: localeState.locale,
              theme: AppTheme.lightThemeData,
              darkTheme: AppTheme.darkThemeData,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) {
                return Theme(
                  data: context.theme.copyWith(
                    textTheme: _getTextTheme(context),
                  ),
                  child: Directionality(
                    textDirection: localeState.isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: PageLoader(child: child!),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  TextTheme _getTextTheme(BuildContext context) {
    return context.isArabicLocale
        ? AppTheme.applyLetterSpacing(
            GoogleFonts.tajawalTextTheme(AppTheme.lightThemeData.textTheme),
            0.0,
          )
        : GoogleFonts.spaceGroteskTextTheme();
  }
}
