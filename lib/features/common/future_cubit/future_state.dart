part of 'future_cubit.dart';

sealed class FutureState<T> extends Equatable {
  final bool isLoading;
  final T? data;

  const FutureState({required this.isLoading, this.data});
  bool get hasData => data != null;
  const factory FutureState.idle([T? data]) = IdleFutureState<T>;
  const factory FutureState.busy([T? data]) = BusyFutureState<T>;
  const factory FutureState.error(BaseAppError appErr, {T? data}) =
      ErrorFutureState<T>;
  const factory FutureState.data(T data) = DataFutureState<T>;

  @override
  List<Object?> get props => [isLoading, data];
}

final class IdleFutureState<T> extends FutureState<T> {
  const IdleFutureState([T? data]) : super(isLoading: false, data: data);
}

final class BusyFutureState<T> extends FutureState<T> {
  const BusyFutureState([T? data]) : super(isLoading: true, data: data);
}

final class DataFutureState<T> extends FutureState<T> {
  const DataFutureState(T data) : super(isLoading: false, data: data);
}

final class ErrorFutureState<T> extends FutureState<T> {
  const ErrorFutureState(this.appErr, {super.data}) : super(isLoading: false);
  final BaseAppError appErr;
  @override
  List<Object?> get props => [...super.props, appErr];
}
