import 'package:sham_cars/utils/utils.dart';

import 'app_error.dart';

class BlocHelpers<E extends BaseAppError> {
  final void Function() emitProcessingRequest;
  final void Function() setAsIdle;
  final bool Function() isBusy;
  final void Function(E err) onError;
  final Duration timeoutDuration;

  const BlocHelpers({
    required this.onError,
    required this.emitProcessingRequest,
    required this.setAsIdle,
    required this.isBusy,
    this.timeoutDuration = const Duration(seconds: 20),
  });

  void handleFuture<T>(
    Future<T> future, {
    required void Function(T value) onSuccess,
    void Function(E err)? onError,
  }) {
    emitProcessingRequest();

    future
        .then(onSuccess)
        .onError((err, stackTrace) {
          pLogger.e('$runtimeType', error: err, stackTrace: stackTrace);
          final appError = err is E ? err : AppError.undefined as E;
          onError != null ? onError(appError) : this.onError(appError);
        })
        .timeout(
          timeoutDuration,
          onTimeout: () {
            if (isBusy()) setAsIdle();
          },
        );
  }
}
