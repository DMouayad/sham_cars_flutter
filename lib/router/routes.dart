import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:sham_cars/features/community/community_screen.dart';
import 'package:sham_cars/features/email_verification/email_verification_screen.dart';
import 'package:sham_cars/features/home/home_cubit.dart';

import 'package:sham_cars/features/home/home_screen.dart';
import 'package:sham_cars/features/login/login_screen.dart';
import 'package:sham_cars/features/questions/question_details_screen.dart';
import 'package:sham_cars/features/signup/screens/signup_screen.dart';
import 'package:sham_cars/features/user_profile/my_activity_screen.dart';
import 'package:sham_cars/features/user_profile/user_profile_screen.dart';
import 'package:sham_cars/features/vehicle/cubits/car_trim_cubit.dart';
import 'package:sham_cars/features/vehicle/cubits/vehicles_list_cubit.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';
import 'package:sham_cars/features/vehicle/trim_community_screen.dart';
import 'package:sham_cars/features/vehicle/vehicle_details_screen.dart';
import 'package:sham_cars/features/vehicle/vehicles_list_screen.dart';
import 'package:sham_cars/utils/utils.dart';
import 'package:sham_cars/widgets/scaffold_with_navbar.dart';

part 'routes.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class RoutePath {
  static const emailVerification = '/profile/emaill-verification';
  static const home = '/home';
  static const profile = '/profile';
  static const login = '/profile/login';
  static const signup = '/profile/signup';
  static const forgotPassword = '/profile/forgot-password';
  static const resetPassword = '/profile/reset-password';
  static const profileActivity = '/profile/activity';
  static const questionDetails = ':id';
  static const vehicles = '/vehicles';
  static const vehicleDetails = '/vehicles/:id';
  static const vehicleCommunityReviews = 'community/reviews';
  static const vehicleCommunityQuestions = 'community/qa';
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
        TypedGoRoute<VehiclesRoute>(path: RoutePath.vehicles, name: 'vehicles'),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CommunityRoute>(
          path: RoutePath.community,
          name: 'community',
          routes: [
            TypedGoRoute<QuestionDetailsRoute>(path: RoutePath.questionDetails),
          ],
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
      RoutePath.emailVerification => context.l10n.emailVerificationScreenTitle,
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
        onOpenTrim: (id, [summary]) =>
            VehicleDetailsRoute(id: id, $extra: summary).push(context),
        onOpenQuestion: (id) => QuestionDetailsRoute(id).push(context),
        onViewAllVehicles: () =>
            StatefulNavigationShell.of(context).goBranch(1),
        onViewAllQuestions: () =>
            StatefulNavigationShell.of(context).goBranch(2),
      ),
    );
  }
}

@TypedGoRoute<LoginRoute>(path: RoutePath.login, name: 'login')
class LoginRoute extends GoRouteData with $LoginRoute {
  final String? redirectTo;
  const LoginRoute({this.redirectTo});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(redirectTo: redirectTo ?? RoutePath.profileActivity);
  }
}

@TypedGoRoute<SignupRoute>(path: RoutePath.signup, name: 'signup')
class SignupRoute extends GoRouteData with $SignupRoute {
  final String? redirectTo;
  const SignupRoute({this.redirectTo});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignupScreen();
  }
}

@TypedGoRoute<AccountVerificationRoute>(
  path: RoutePath.emailVerification,
  name: 'email_verification',
)
@immutable
class AccountVerificationRoute extends GoRouteData
    with $AccountVerificationRoute {
  const AccountVerificationRoute(this.$extra);
  final String $extra; // email
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmailVerificationScreen(email: $extra);
  }
}

@immutable
@TypedGoRoute<ProfileRoute>(path: RoutePath.profile)
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserProfileScreen();
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
        onOpenTrim: (summary) =>
            VehicleDetailsRoute(id: summary.id, $extra: summary).push(context),
      ),
    );
  }
}

@immutable
@TypedGoRoute<VehicleDetailsRoute>(
  path: RoutePath.vehicleDetails,
  name: 'vehicle_details',
  routes: [
    TypedGoRoute<VehicleCommunityReviewsRoute>(
      path: RoutePath.vehicleCommunityReviews,
      name: 'vehicle_community_reviews',
    ),
    TypedGoRoute<VehicleCommunityQuestionsRoute>(
      path: RoutePath.vehicleCommunityQuestions,
      name: 'vehicle_community_qa',
    ),
  ],
)
class VehicleDetailsRoute extends GoRouteData with $VehicleDetailsRoute {
  const VehicleDetailsRoute({required this.id, this.$extra});
  final CarTrimSummary? $extra;
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (context) =>
          CarTrimCubit(context.read<CarDataRepository>())..load(id),
      child: VehicleDetailsScreen(trimId: id, trimSummary: $extra),
    );
  }
}

@immutable
class VehicleCommunityReviewsRoute extends GoRouteData
    with $VehicleCommunityReviewsRoute {
  const VehicleCommunityReviewsRoute(this.id, {required this.title});

  final int id;
  final String title;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TrimCommunityScreen(
      trimId: id,
      initialTab: 0, // 0 = reviews
      trimTitle: title,
    );
  }
}

@immutable
class VehicleCommunityQuestionsRoute extends GoRouteData
    with $VehicleCommunityQuestionsRoute {
  const VehicleCommunityQuestionsRoute(this.id, {required this.title});

  final int id;
  final String title;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TrimCommunityScreen(
      trimId: id,
      initialTab: 1, // 1 = Q&A
      trimTitle: title,
    );
  }
}

@immutable
class QuestionDetailsRoute extends GoRouteData with $QuestionDetailsRoute {
  const QuestionDetailsRoute(this.id);
  final int id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return QuestionDetailsScreen(id: id);
  }
}

@immutable
class CommunityRoute extends GoRouteData with $CommunityRoute {
  const CommunityRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CommunityScreen(
      onOpenVehicle: (id) => VehicleDetailsRoute(id: id).push(context),
      onOpenQuestion: (id) => QuestionDetailsRoute(id).push(context),
    );
  }
}

@TypedGoRoute<ProfileActivityRoute>(
  path: RoutePath.profileActivity,
  name: 'profile_activity',
)
@immutable
class ProfileActivityRoute extends GoRouteData with $ProfileActivityRoute {
  const ProfileActivityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyActivityScreen();
  }
}
