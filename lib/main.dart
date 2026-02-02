import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sham_cars/api/cache.dart';

import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/phone_verification/repositories.dart';
import 'package:sham_cars/features/user/api_user_repository.dart';
import 'package:sham_cars/features/user/local_user_repository.dart';

import 'features/auth/repositories.dart';
import 'utils/utils.dart';
import 'app.dart';

import 'api/http_client_factory.dart'
    if (dart.library.js_interop) 'api/http_client_factory_web.dart'
    as http_factory;

/// Bootstrap our app with required dependencies
void _bootstrap(RestClient restClient) {
  GetIt.I.registerSingleton<LocalUserRepository>(LocalUserRepository());
  GetIt.I.registerSingleton<ITokensRepository>(TokensRepository());
  GetIt.I.registerSingleton<ApiUserRepository>(ApiUserRepository(restClient));

  GetIt.I.registerSingleton<IAuthRepository>(
    AuthRepository(
      restClient,
      GetIt.I.get<ITokensRepository>(),
      GetIt.I.get<LocalUserRepository>(),
      GetIt.I.get<ApiUserRepository>(),
    ),
  );
  GetIt.I.registerSingleton(AuthNotifier(GetIt.I.get<IAuthRepository>()));
  GetIt.I.registerLazySingleton(
    () => ApiPhoneVerificationRepository(restClient),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setup `HydratedBloc` storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  Bloc.observer = AppBlocObserver();
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final restClient = RestClient(http_factory.httpClient());
  _bootstrap(restClient);
  final cache = ResponseCache();
  runApp(MainApp(restClient: restClient, responseCache: cache));
}
