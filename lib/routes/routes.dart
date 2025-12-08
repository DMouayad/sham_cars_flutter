import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sham_cars/features/home/home_screen.dart';
import 'package:sham_cars/features/login/login_screen.dart';
import 'package:sham_cars/features/phone_verification/phone_verification_screen.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/features/signup/models/signup_method.dart';
import 'package:sham_cars/features/signup/screens/signup_screen.dart';
import 'package:sham_cars/features/user/models.dart';
import 'package:sham_cars/features/user_profile/user_profile_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeScreenRoute>(path: '/')
@immutable
class HomeScreenRoute extends GoRouteData with $HomeScreenRoute {
  const HomeScreenRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@TypedGoRoute<LoginScreenRoute>(path: '/login')
@immutable
class LoginScreenRoute extends GoRouteData with $LoginScreenRoute {
  final String? redirectTo;

  const LoginScreenRoute({this.redirectTo});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(
      redirectTo: redirectTo ?? const UserProfileScreenRoute().location,
    );
  }
}

@TypedGoRoute<SignupScreenRoute>(path: '/signup')
@immutable
class SignupScreenRoute extends GoRouteData with $SignupScreenRoute {
  final Role role;
  final SignupMethod method;
  const SignupScreenRoute({required this.role, required this.method});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignupScreen(signupAs: role, method: method);
  }
}

@TypedGoRoute<PhoneVerificationScreenRoute>(path: '/phone-verification')
@immutable
class PhoneVerificationScreenRoute extends GoRouteData
    with $PhoneVerificationScreenRoute {
  const PhoneVerificationScreenRoute(this.$extra);
  final SignupCubit $extra;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PhoneVerificationScreen(signupCubit: $extra);
  }
}

@TypedGoRoute<UserProfileScreenRoute>(path: '/user-profile')
@immutable
class UserProfileScreenRoute extends GoRouteData with $UserProfileScreenRoute {
  const UserProfileScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserProfileScreen();
  }
}
