// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $homeScreenRoute,
  $loginScreenRoute,
  $signupScreenRoute,
  $phoneVerificationScreenRoute,
  $userProfileScreenRoute,
];

RouteBase get $homeScreenRoute =>
    GoRouteData.$route(path: '/', factory: $HomeScreenRoute._fromState);

mixin $HomeScreenRoute on GoRouteData {
  static HomeScreenRoute _fromState(GoRouterState state) =>
      const HomeScreenRoute();

  @override
  String get location => GoRouteData.$location('/');

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

RouteBase get $loginScreenRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginScreenRoute._fromState);

mixin $LoginScreenRoute on GoRouteData {
  static LoginScreenRoute _fromState(GoRouterState state) =>
      LoginScreenRoute(redirectTo: state.uri.queryParameters['redirect-to']);

  LoginScreenRoute get _self => this as LoginScreenRoute;

  @override
  String get location => GoRouteData.$location(
    '/login',
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

RouteBase get $signupScreenRoute =>
    GoRouteData.$route(path: '/signup', factory: $SignupScreenRoute._fromState);

mixin $SignupScreenRoute on GoRouteData {
  static SignupScreenRoute _fromState(GoRouterState state) => SignupScreenRoute(
    role: _$RoleEnumMap._$fromName(state.uri.queryParameters['role']!)!,
    method: _$SignupMethodEnumMap._$fromName(
      state.uri.queryParameters['method']!,
    )!,
  );

  SignupScreenRoute get _self => this as SignupScreenRoute;

  @override
  String get location => GoRouteData.$location(
    '/signup',
    queryParams: {
      'role': _$RoleEnumMap[_self.role],
      'method': _$SignupMethodEnumMap[_self.method],
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

const _$RoleEnumMap = {
  Role.patient: 'patient',
  Role.physician: 'physician',
  Role.guest: 'guest',
};

const _$SignupMethodEnumMap = {
  SignupMethod.email: 'email',
  SignupMethod.phone: 'phone',
};

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}

RouteBase get $phoneVerificationScreenRoute => GoRouteData.$route(
  path: '/phone-verification',
  factory: $PhoneVerificationScreenRoute._fromState,
);

mixin $PhoneVerificationScreenRoute on GoRouteData {
  static PhoneVerificationScreenRoute _fromState(GoRouterState state) =>
      PhoneVerificationScreenRoute(state.extra as SignupCubit);

  PhoneVerificationScreenRoute get _self =>
      this as PhoneVerificationScreenRoute;

  @override
  String get location => GoRouteData.$location('/phone-verification');

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

RouteBase get $userProfileScreenRoute => GoRouteData.$route(
  path: '/user-profile',
  factory: $UserProfileScreenRoute._fromState,
);

mixin $UserProfileScreenRoute on GoRouteData {
  static UserProfileScreenRoute _fromState(GoRouterState state) =>
      const UserProfileScreenRoute();

  @override
  String get location => GoRouteData.$location('/user-profile');

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
