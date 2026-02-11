// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $mainScaffoldRoute,
  $loginRoute,
  $signupRoute,
  $forgotPasswordRoute,
  $resetPasswordRoute,
  $otpPasswordResetRoute,
  $accountVerificationRoute,
  $profileRoute,
  $vehicleDetailsRoute,
  $questionDetailsRoute,
  $profileActivityRoute,
  $hotTopicsRoute,
  $hotTopicDetailsRoute,
  $trendingCarsRoute,
];

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
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/community',
          name: 'community',
          factory: $CommunityRoute._fromState,
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

mixin $CommunityRoute on GoRouteData {
  static CommunityRoute _fromState(GoRouterState state) =>
      CommunityRoute(filter: state.uri.queryParameters['filter']);

  CommunityRoute get _self => this as CommunityRoute;

  @override
  String get location => GoRouteData.$location(
    '/community',
    queryParams: {if (_self.filter != null) 'filter': _self.filter},
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

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  name: 'login',
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) =>
      LoginRoute(redirectTo: state.uri.queryParameters['redirect-to']);

  LoginRoute get _self => this as LoginRoute;

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

RouteBase get $signupRoute => GoRouteData.$route(
  path: '/signup',
  name: 'signup',
  factory: $SignupRoute._fromState,
);

mixin $SignupRoute on GoRouteData {
  static SignupRoute _fromState(GoRouterState state) =>
      SignupRoute(redirectTo: state.uri.queryParameters['redirect-to']);

  SignupRoute get _self => this as SignupRoute;

  @override
  String get location => GoRouteData.$location(
    '/signup',
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

RouteBase get $forgotPasswordRoute => GoRouteData.$route(
  path: '/forgot-password',
  name: 'forgot_password',
  factory: $ForgotPasswordRoute._fromState,
);

mixin $ForgotPasswordRoute on GoRouteData {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      const ForgotPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forgot-password');

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

RouteBase get $resetPasswordRoute => GoRouteData.$route(
  path: '/reset-password',
  name: 'reset_password',
  factory: $ResetPasswordRoute._fromState,
);

mixin $ResetPasswordRoute on GoRouteData {
  static ResetPasswordRoute _fromState(GoRouterState state) =>
      const ResetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/reset-password');

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

RouteBase get $otpPasswordResetRoute => GoRouteData.$route(
  path: '/otp-password-reset',
  name: 'otp_password_reset',
  factory: $OtpPasswordResetRoute._fromState,
);

mixin $OtpPasswordResetRoute on GoRouteData {
  static OtpPasswordResetRoute _fromState(GoRouterState state) =>
      OtpPasswordResetRoute(state.extra as String);

  OtpPasswordResetRoute get _self => this as OtpPasswordResetRoute;

  @override
  String get location => GoRouteData.$location('/otp-password-reset');

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

RouteBase get $accountVerificationRoute => GoRouteData.$route(
  path: '/emaill-verification',
  name: 'email_verification',
  factory: $AccountVerificationRoute._fromState,
);

mixin $AccountVerificationRoute on GoRouteData {
  static AccountVerificationRoute _fromState(GoRouterState state) =>
      AccountVerificationRoute(state.extra as String);

  AccountVerificationRoute get _self => this as AccountVerificationRoute;

  @override
  String get location => GoRouteData.$location('/emaill-verification');

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

RouteBase get $profileRoute =>
    GoRouteData.$route(path: '/profile', factory: $ProfileRoute._fromState);

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

RouteBase get $vehicleDetailsRoute => GoRouteData.$route(
  path: '/vehicles/:id',
  name: 'vehicle_details',
  factory: $VehicleDetailsRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'community/reviews',
      name: 'vehicle_community_reviews',
      factory: $VehicleCommunityReviewsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'community/qa',
      name: 'vehicle_community_qa',
      factory: $VehicleCommunityQuestionsRoute._fromState,
    ),
  ],
);

mixin $VehicleDetailsRoute on GoRouteData {
  static VehicleDetailsRoute _fromState(GoRouterState state) =>
      VehicleDetailsRoute(
        id: int.parse(state.pathParameters['id']!),
        $extra: state.extra as CarTrimSummary?,
      );

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

mixin $VehicleCommunityReviewsRoute on GoRouteData {
  static VehicleCommunityReviewsRoute _fromState(GoRouterState state) =>
      VehicleCommunityReviewsRoute(
        int.parse(state.pathParameters['id']!),
        title: state.uri.queryParameters['title']!,
      );

  VehicleCommunityReviewsRoute get _self =>
      this as VehicleCommunityReviewsRoute;

  @override
  String get location => GoRouteData.$location(
    '/vehicles/${Uri.encodeComponent(_self.id.toString())}/community/reviews',
    queryParams: {'title': _self.title},
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

mixin $VehicleCommunityQuestionsRoute on GoRouteData {
  static VehicleCommunityQuestionsRoute _fromState(GoRouterState state) =>
      VehicleCommunityQuestionsRoute(
        int.parse(state.pathParameters['id']!),
        title: state.uri.queryParameters['title']!,
      );

  VehicleCommunityQuestionsRoute get _self =>
      this as VehicleCommunityQuestionsRoute;

  @override
  String get location => GoRouteData.$location(
    '/vehicles/${Uri.encodeComponent(_self.id.toString())}/community/qa',
    queryParams: {'title': _self.title},
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

RouteBase get $questionDetailsRoute => GoRouteData.$route(
  path: '/questions/:id',
  factory: $QuestionDetailsRoute._fromState,
);

mixin $QuestionDetailsRoute on GoRouteData {
  static QuestionDetailsRoute _fromState(GoRouterState state) =>
      QuestionDetailsRoute(int.parse(state.pathParameters['id']!));

  QuestionDetailsRoute get _self => this as QuestionDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/questions/${Uri.encodeComponent(_self.id.toString())}',
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

RouteBase get $profileActivityRoute => GoRouteData.$route(
  path: '/profile/activity',
  name: 'profile_activity',
  factory: $ProfileActivityRoute._fromState,
);

mixin $ProfileActivityRoute on GoRouteData {
  static ProfileActivityRoute _fromState(GoRouterState state) =>
      const ProfileActivityRoute();

  @override
  String get location => GoRouteData.$location('/profile/activity');

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

RouteBase get $hotTopicsRoute => GoRouteData.$route(
  path: '/hot-topics',
  factory: $HotTopicsRoute._fromState,
);

mixin $HotTopicsRoute on GoRouteData {
  static HotTopicsRoute _fromState(GoRouterState state) =>
      const HotTopicsRoute();

  @override
  String get location => GoRouteData.$location('/hot-topics');

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

RouteBase get $hotTopicDetailsRoute => GoRouteData.$route(
  path: '/hot-topics/:id',
  factory: $HotTopicDetailsRoute._fromState,
);

mixin $HotTopicDetailsRoute on GoRouteData {
  static HotTopicDetailsRoute _fromState(GoRouterState state) =>
      HotTopicDetailsRoute(
        id: int.parse(state.pathParameters['id']!),
        title: state.uri.queryParameters['title'],
      );

  HotTopicDetailsRoute get _self => this as HotTopicDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/hot-topics/${Uri.encodeComponent(_self.id.toString())}',
    queryParams: {if (_self.title != null) 'title': _self.title},
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

RouteBase get $trendingCarsRoute => GoRouteData.$route(
  path: '/trending-cars',
  factory: $TrendingCarsRoute._fromState,
);

mixin $TrendingCarsRoute on GoRouteData {
  static TrendingCarsRoute _fromState(GoRouterState state) =>
      const TrendingCarsRoute();

  @override
  String get location => GoRouteData.$location('/trending-cars');

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
