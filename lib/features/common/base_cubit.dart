import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/utils/src/app_error.dart';

abstract class BaseCubit<T extends BaseState<T>> extends Cubit<T> {
  BaseCubit(super.initialState);
}

abstract class BaseState<T> {
  bool get isBusy;
  BaseAppError? get appErr;
}
