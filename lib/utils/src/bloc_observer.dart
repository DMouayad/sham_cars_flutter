part of '../utils.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    sLogger.i(
      'Bloc change: ${bloc.runtimeType} | currentState: ${change.currentState} | nextState: ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    sLogger.e('${bloc.runtimeType}($error)\n${stackTrace.toString()}');
    super.onError(bloc, error, stackTrace);
  }
}
