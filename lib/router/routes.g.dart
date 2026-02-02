// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$mainScaffoldRoute];

RouteBase get $mainScaffoldRoute => StatefulShellRouteData.$route(
  factory: $MainScaffoldRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          name: 'home',
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/vehicles',
          name: 'vehicles',
          factory: $VehiclesRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':id',
              factory: $VehicleDetailsRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/community',
          name: 'community',
          factory: $CommunityRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':id',
              factory: $QuestionDetailsRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          name: 'profile',
          factory: $ProfileRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/profile/login',
          name: 'login',
          factory: $LoginRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/profile/signup',
          name: 'signup',
          factory: $SignupRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/profile/emaill-verification',
          name: 'email_verification',
          factory: $AccountVerificationRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/compare',
          name: 'compare',
          factory: $CompareRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MainScaffoldRouteExtension on MainScaffoldRoute {
  static MainScaffoldRoute _fromState(GoRouterState state) =>
      const MainScaffoldRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $VehiclesRoute on GoRouteData {
  static VehiclesRoute _fromState(GoRouterState state) => const VehiclesRoute();

  @override
  String get location => GoRouteData.$location('/vehicles');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $VehicleDetailsRoute on GoRouteData {
  static VehicleDetailsRoute _fromState(GoRouterState state) =>
      VehicleDetailsRoute(state.extra as CarTrimSummary);

  VehicleDetailsRoute get _self => this as VehicleDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/vehicles/${Uri.encodeComponent(_self.id.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin $CommunityRoute on GoRouteData {
  static CommunityRoute _fromState(GoRouterState state) =>
      const CommunityRoute();

  @override
  String get location => GoRouteData.$location('/community');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $QuestionDetailsRoute on GoRouteData {
  static QuestionDetailsRoute _fromState(GoRouterState state) =>
      QuestionDetailsRoute(int.parse(state.pathParameters['id']!));

  QuestionDetailsRoute get _self => this as QuestionDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/community/${Uri.encodeComponent(_self.id.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) =>
      LoginRoute(redirectTo: state.uri.queryParameters['redirect-to']);

  LoginRoute get _self => this as LoginRoute;

  @override
  String get location => GoRouteData.$location(
    '/profile/login',
    queryParams: {
      if (_self.redirectTo != null) 'redirect-to': _self.redirectTo,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SignupRoute on GoRouteData {
  static SignupRoute _fromState(GoRouterState state) => const SignupRoute();

  @override
  String get location => GoRouteData.$location('/profile/signup');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AccountVerificationRoute on GoRouteData {
  static AccountVerificationRoute _fromState(GoRouterState state) =>
      AccountVerificationRoute(state.extra as String);

  AccountVerificationRoute get _self => this as AccountVerificationRoute;

  @override
  String get location => GoRouteData.$location('/profile/emaill-verification');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin $CompareRoute on GoRouteData {
  static CompareRoute _fromState(GoRouterState state) => const CompareRoute();

  @override
  String get location => GoRouteData.$location('/compare');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
