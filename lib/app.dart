import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sham_cars/api/cache.dart';
import 'package:sham_cars/api/rest_client.dart';

import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/home/home_repository.dart';
import 'package:sham_cars/features/support/support_repository.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/features/localization/cubit/localization_cubit.dart';
import 'package:sham_cars/features/theme/theme_cubit.dart';
import 'package:sham_cars/features/user_profile/repositories/user_activity_repository.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';
import 'package:sham_cars/l10n/app_localizations.dart';
import 'package:sham_cars/router/redirect_helper.dart';
import 'package:sham_cars/router/routes.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/page_loader.dart';

import 'features/community/community_cubit.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.restClient,
    required this.responseCache,
  });
  final RestClient restClient;
  final ResponseCache responseCache;

  static final _appRouter = GoRouter(
    routes: $appRoutes,
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePath.home,
    debugLogDiagnostics: true,
    refreshListenable: GetIt.I.get<AuthNotifier>(),
    redirect: redirectHelper,
  );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _appRouter,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(lazy: false, create: (_) => ThemeCubit()),
          BlocProvider(lazy: false, create: (_) => LocalizationCubit()),
          RepositoryProvider(
            lazy: true,
            create: (ctx) => UserActivityRepository(restClient),
          ),
          RepositoryProvider(
            lazy: true,
            create: (ctx) => SupportRepository(restClient, responseCache),
          ),
          RepositoryProvider(
            create: (_) => CommunityRepository(restClient, responseCache),
          ),
          RepositoryProvider(
            create: (_) => CarDataRepository(restClient, cache: responseCache),
          ),
          RepositoryProvider(
            create: (context) =>
                HomeRepository(responseCache, context.read(), context.read()),
          ),
          BlocProvider(
            lazy: true,
            create: (context) => CommunityCubit(context.read())..load(),
          ),
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
              theme: AppTheme.corporateTheme,
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
    final textTheme = context.isDarkMode
        ? AppTheme.darkThemeData.textTheme
        : AppTheme.corporateTheme.textTheme;
    return context.isArabicLocale
        ? AppTheme.applyLetterSpacing(
            GoogleFonts.tajawalTextTheme(textTheme),
            0.0,
          )
        : GoogleFonts.spaceGroteskTextTheme(textTheme);
  }
}
