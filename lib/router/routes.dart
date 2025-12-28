import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:sham_cars/features/community/community_page.dart';

import 'package:sham_cars/features/home/home_screen.dart';
import 'package:sham_cars/features/login/login_screen.dart';
import 'package:sham_cars/features/phone_verification/phone_verification_screen.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/features/signup/screens/signup_screen.dart';
import 'package:sham_cars/features/user_profile/user_profile_screen.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/scaffold_with_navbar.dart';

part 'routes.g.dart';

class RoutePath {
  static const accountVerification = '/profile/verification';
  static const home = '/home';
  static const profile = '/profile';
  static const login = '/profile/login';
  static const signup = '/profile/signup';
  static const forgotPassword = '/profile/forgot-password';
  static const resetPassword = '/profile/reset-password';
  static const community = '/community';
}

@TypedStatefulShellRoute<MainScaffoldRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<HomeRoute>(path: RoutePath.home, name: 'home')],
    ),

    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CommunityRoute>(
          path: RoutePath.community,
          name: 'community',
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<ProfileRoute>(path: RoutePath.profile, name: 'profile'),
        TypedGoRoute<LoginRoute>(path: RoutePath.login, name: 'login'),
        TypedGoRoute<SignupRoute>(path: RoutePath.signup, name: 'signup'),
        TypedGoRoute<AccountVerificationRoute>(
          path: RoutePath.accountVerification,
          name: 'phoneVerification',
        ),
      ],
    ),
  ],
)
class MainScaffoldRoute extends StatefulShellRouteData {
  const MainScaffoldRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldWithNavBar(
      title: title(context, state),
      navigationShell: navigationShell,
    );
  }

  String title(BuildContext context, GoRouterState state) {
    return switch (state.matchedLocation) {
      RoutePath.profile => context.l10n.userProfileScreenTitle,
      RoutePath.accountVerification =>
        context.l10n.phoneVerificationScreenTitle,
      _ => context.l10n.appName,
    };
  }
}

@immutable
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@immutable
class LoginRoute extends GoRouteData with $LoginRoute {
  final String? redirectTo;

  const LoginRoute({this.redirectTo});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(redirectTo: redirectTo ?? const ProfileRoute().location);
  }
}

@immutable
class SignupRoute extends GoRouteData with $SignupRoute {
  const SignupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignupScreen();
  }
}

@immutable
class CommunityRoute extends GoRouteData with $CommunityRoute {
  const CommunityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CommunityPage();
  }
}

@immutable
class AccountVerificationRoute extends GoRouteData
    with $AccountVerificationRoute {
  const AccountVerificationRoute(this.$extra);
  final SignupCubit $extra;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PhoneVerificationScreen(signupCubit: $extra);
  }
}

@immutable
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserProfileScreen();
  }
}
