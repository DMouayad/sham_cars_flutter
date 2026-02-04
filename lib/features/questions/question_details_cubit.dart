import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/utils/src/app_error.dart';

class QuestionDetailsState {
  final Question? question;
  final bool isLoading;
  final bool isSubmitting;
  final Object? error;
  final String? submitError;

  const QuestionDetailsState({
    this.question,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.submitError,
  });

  QuestionDetailsState copyWith({
    Question? question,
    bool? isLoading,
    bool? isSubmitting,
    Object? error,
    String? submitError,
    bool clearErrors = false,
  }) {
    return QuestionDetailsState(
      question: question ?? this.question,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearErrors ? null : (error ?? this.error),
      submitError: clearErrors ? null : (submitError ?? this.submitError),
    );
  }
}

class QuestionDetailsCubit extends Cubit<QuestionDetailsState> {
  final CommunityRepository _communityRepo;
  int? _questionId;

  QuestionDetailsCubit(this._communityRepo)
    : super(const QuestionDetailsState());

  Future<void> load(int questionId) async {
    _questionId = questionId;
    emit(state.copyWith(isLoading: true, clearErrors: true));
    try {
      final question = await _communityRepo.getQuestion(questionId);
      emit(state.copyWith(question: question, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false));
    }
  }

  Future<void> refresh() async {
    if (_questionId != null) {
      await load(_questionId!);
    }
  }

  Future<bool> submitAnswer({required String body}) async {
    if (_questionId == null) return false;

    emit(state.copyWith(isSubmitting: true, clearErrors: true));
    try {
      final accessToken = await GetIt.I.get<ITokensRepository>().get();
      if (accessToken == null) {
        throw AppError.unauthenticated;
      }
      await _communityRepo.postAnswer(
        questionId: _questionId!,
        body: body,
        accessToken: accessToken,
      );
      await refresh();
      return true;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, submitError: e.toString()));
      return false;
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
