import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/router/routes.dart';

FutureOr<String?> redirectHelper(BuildContext context, GoRouterState state) {
  final authNotifier = GetIt.I.get<AuthNotifier>();

  if (!authNotifier.isLoggedIn && state.isProtectedRoute) {
    final fromLocation = state.uri.toString();

    return LoginRoute(redirectTo: fromLocation).location;
  }
  return null;
}

extension on GoRouterState {
  bool get isProtectedRoute {
    return [
      RoutePath.profile,
      RoutePath.profileActivity,
    ].contains(matchedLocation);
  }
}
