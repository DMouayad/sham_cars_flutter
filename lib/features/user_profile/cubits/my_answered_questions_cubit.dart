import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/common/paged_state.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/utils/src/app_error.dart';

import '../repositories/user_activity_repository.dart';

class MyAnsweredQuestionsCubit extends Cubit<PagedState<Question>> {
  MyAnsweredQuestionsCubit(this._repo) : super(const PagedState<Question>());

  final UserActivityRepository _repo;
  static const _limit = 10;

  Future<void> loadInitial() async {
    emit(
      state.copyWith(
        loadingInitial: true,
        clearError: true,
        items: const [],
        skip: 0,
        hasMore: true,
      ),
    );

    try {
      final token = await GetIt.I.get<ITokensRepository>().get();
      if (token == null) throw AppError.unauthenticated;

      final items = await _repo.getMyAnsweredQuestions(
        accessToken: token,
        limit: _limit,
        skip: 0,
      );

      emit(
        state.copyWith(
          loadingInitial: false,
          items: items,
          skip: items.length,
          hasMore: items.length == _limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingInitial: false, error: e));
    }
  }

  Future<void> loadMore() async {
    if (state.loadingInitial || state.loadingMore || !state.hasMore) return;

    emit(state.copyWith(loadingMore: true, clearError: true));
    try {
      final token = await GetIt.I.get<ITokensRepository>().get();
      if (token == null) throw AppError.unauthenticated;

      final next = await _repo.getMyAnsweredQuestions(
        accessToken: token,
        limit: _limit,
        skip: state.skip,
      );

      emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...next],
          skip: state.skip + next.length,
          hasMore: next.length == _limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e));
    }
  }

  Future<void> refresh() => loadInitial();
}
