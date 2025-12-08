import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/utils/src/bloc_helpers.dart';

part 'future_state.dart';

class FutureCubit<T> extends Cubit<FutureState<T>> {
  late final BlocHelpers _helpers;

  FutureCubit([FutureState<T>? initialState])
    : super(initialState ?? const FutureState.idle()) {
    _helpers = BlocHelpers(
      emitProcessingRequest: () => emit(FutureState.busy(state.data)),
      setAsIdle: () => emit(FutureState.idle(state.data)),
      isBusy: () => state.isLoading,
      onError: (err) => emit(FutureState.error(err, data: state.data)),
    );
  }

  void runFuture(Future<T> future) {
    _helpers.handleFuture(
      future,
      onSuccess: (data) => emit(FutureState.data(data)),
    );
  }
}
