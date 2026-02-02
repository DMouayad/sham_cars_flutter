import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:go_router/go_router.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/community/community_cubit.dart';
import 'package:sham_cars/features/community/community_screen.dart';
import 'package:sham_cars/features/compare/compare_screen.dart';
import 'package:sham_cars/features/home/home_cubit.dart';

import 'package:sham_cars/features/home/home_screen.dart';
import 'package:sham_cars/features/login/login_screen.dart';
import 'package:sham_cars/features/phone_verification/phone_verification_screen.dart';
import 'package:sham_cars/features/questions/question_details_screen.dart';
import 'package:sham_cars/features/questions/questions_list_screen.dart';
import 'package:sham_cars/features/signup/cubit/signup_cubit.dart';
import 'package:sham_cars/features/signup/screens/signup_screen.dart';
import 'package:sham_cars/features/user_profile/cubit/user_profile_cubit.dart';
import 'package:sham_cars/features/user_profile/user_profile_screen.dart';
import 'package:sham_cars/features/vehicle/cubits/car_trim_cubit.dart';
import 'package:sham_cars/features/vehicle/cubits/vehicles_list_cubit.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';
import 'package:sham_cars/features/vehicle/vehicle_details_screen.dart';
import 'package:sham_cars/features/vehicle/vehicles_list_screen.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/scaffold_with_navbar.dart';

part 'routes.g.dart';

class RoutePath {
  static const emailVerification = '/profile/emaill-verification';
  static const home = '/home';
  static const profile = '/profile';
  static const login = '/profile/login';
  static const signup = '/profile/signup';
  static const forgotPassword = '/profile/forgot-password';
  static const resetPassword = '/profile/reset-password';
  static const questions = 'questions';
  static const askQuestion = 'new';
  static const questionDetails = ':id';
  static const vehicles = '/vehicles';
  static const vehicleDetails = ':id';
  static const compare = '/compare';
  static const community = '/community';
}

@TypedStatefulShellRoute<MainScaffoldRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<HomeRoute>(path: RoutePath.home, name: 'home')],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<VehiclesRoute>(
          path: RoutePath.vehicles,
          name: 'vehicles',
          routes: [
            TypedGoRoute<VehicleDetailsRoute>(path: RoutePath.vehicleDetails),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CommunityRoute>(
          path: RoutePath.community,
          name: 'community',
          routes: [
            // TypedGoRoute<QuestionsRoute>(
            //   path: RoutePath.questions,
            //   routes: [
            //   ],
            // ),
            TypedGoRoute<QuestionDetailsRoute>(path: RoutePath.questionDetails),
          ],
        ),
      ],
    ),

    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<ProfileRoute>(path: RoutePath.profile, name: 'profile'),
        TypedGoRoute<LoginRoute>(path: RoutePath.login, name: 'login'),
        TypedGoRoute<SignupRoute>(path: RoutePath.signup, name: 'signup'),
        TypedGoRoute<AccountVerificationRoute>(
          path: RoutePath.emailVerification,
          name: 'email_verification',
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CompareRoute>(path: RoutePath.compare, name: 'compare'),
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
      RoutePath.emailVerification => context.l10n.phoneVerificationScreenTitle,
      _ => context.l10n.appName,
    };
  }
}

@immutable
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (context) => HomeCubit(context.read())..load(),
      child: HomeScreen(
        onOpenModel: (id) => VehicleDetailsRoute(id).push(context),
        onOpenQuestion: (id) => QuestionDetailsRoute(id).go(context),
        onViewAllVehicles: () =>
            StatefulNavigationShell.of(context).goBranch(1),
        onViewAllQuestions: () =>
            StatefulNavigationShell.of(context).goBranch(2),
      ),
    );
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
    return BlocProvider(
      create: (context) =>
          UserProfileCubit(GetIt.I.get<AuthNotifier>().currentUser),
      child: const UserProfileScreen(),
    );
  }
}

@immutable
class VehiclesRoute extends GoRouteData with $VehiclesRoute {
  const VehiclesRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (ctx) => VehiclesListCubit(ctx.read<CarDataRepository>())..init(),
      child: VehiclesScreen(
        onOpenModel: (id) => VehicleDetailsRoute(id).push(context),
      ),
    );
  }
}

@immutable
class VehicleDetailsRoute extends GoRouteData with $VehicleDetailsRoute {
  const VehicleDetailsRoute(this.id);
  final int id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (context) =>
          CarTrimCubit(context.read<CarDataRepository>())..load(id),
      child: const VehicleDetailScreen(),
    );
  }
}

// @immutable
// class QuestionsRoute extends GoRouteData with $QuestionsRoute {
//   const QuestionsRoute();
//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return QuestionsScreen(
//       onOpenQuestion: (id) => QuestionDetailsRoute(id).push(context),
//     );
//   }
// }

@immutable
class QuestionDetailsRoute extends GoRouteData with $QuestionDetailsRoute {
  const QuestionDetailsRoute(this.id);
  final int id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return QuestionDetailsScreen(id: int.parse(state.pathParameters['id']!));
  }
}

@immutable
class CompareRoute extends GoRouteData with $CompareRoute {
  const CompareRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CompareScreen();
  }
}

@immutable
class CommunityRoute extends GoRouteData with $CommunityRoute {
  const CommunityRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (context) =>
          CommunityCubit(context.read(), context.read())..load(),
      child: CommunityScreen(
        onOpenVehicle: (id) => VehicleDetailsRoute(id).push(context),
        onOpenQuestion: (id) => QuestionDetailsRoute(id).push(context),
      ),
    );
  }
}
