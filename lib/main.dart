import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/medical_entities/repositories.dart';
import 'package:sham_cars/features/phone_verification/repositories.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'features/auth/repositories.dart';
import 'features/search/repositories.dart';
import 'utils/utils.dart';
import 'app.dart';

import 'api/http_client_factory.dart'
    if (dart.library.js_interop) 'api/http_client_factory_web.dart'
    as http_factory;

/// Bootstrap our app with required dependencies

Future<void> _bootstrap() async {
  GetIt.I.registerSingleton<IAuthRepository>(AuthRepository());
  GetIt.I.registerSingleton<IMedicalEntitiesRepository>(
    ApiMedicalEntitiesRepository(),
  );
  GetIt.I.registerSingleton<SearchRepository>(ApiSearchRepository());
  GetIt.I.registerLazySingleton(() => ApiPhoneVerificationRepository());
  GetIt.I.registerSingleton<ITokensRepository>(TokensRepository());

  RestClient.init(http_factory.httpClient());
  await GetIt.I.allReady();
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

  await _bootstrap();
  runApp(const MainApp());
}
