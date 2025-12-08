// GoRouter configuration
import 'package:go_router/go_router.dart';

import 'routes.dart';

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: const HomeScreenRoute().location,
  debugLogDiagnostics: true,
);
