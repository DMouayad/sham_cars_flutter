import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/utils/src/app_error.dart';

class CommunityActionsState {
  final bool isSubmitting;
  final String? submitError;

  const CommunityActionsState({this.isSubmitting = false, this.submitError});

  CommunityActionsState copyWith({
    bool? isSubmitting,
    String? submitError,
    bool clearError = false,
  }) {
    return CommunityActionsState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearError ? null : (submitError ?? this.submitError),
    );
  }
}

class CommunityActionsCubit extends Cubit<CommunityActionsState> {
  CommunityActionsCubit(this._repo) : super(const CommunityActionsState());
  final CommunityRepository _repo;

  Future<bool> submitQuestion({
    required int carTrimId,
    required String title,
    required String body,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final token = await GetIt.I.get<ITokensRepository>().get();
      if (token == null) throw AppError.unauthenticated;

      await _repo.postQuestion(
        carTrimId: carTrimId,
        title: title,
        body: body,
        accessToken: token,
      );
      return true;
    } catch (e) {
      emit(state.copyWith(submitError: e.toString()));
      return false;
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  Future<bool> submitReview({
    required int carTrimId,
    required int rating,
    required String comment,
    String? title,
    String? cityCode,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final token = await GetIt.I.get<ITokensRepository>().get();
      if (token == null) throw AppError.unauthenticated;

      await _repo.postReview(
        carTrimId: carTrimId,
        rating: rating,
        comment: comment,
        title: title,
        cityCode: cityCode,
        accessToken: token,
      );
      return true;
    } catch (e) {
      emit(state.copyWith(submitError: e.toString()));
      return false;
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
