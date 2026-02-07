import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/questions/models.dart';

class ModelQuestionsState {
  const ModelQuestionsState({
    this.loadingInitial = false,
    this.loadingMore = false,
    this.error,
    this.questions = const [],
    this.skip = 0,
    this.hasMore = true,
  });

  final bool loadingInitial;
  final bool loadingMore;
  final String? error;
  final List<Question> questions;
  final int skip;
  final bool hasMore;

  ModelQuestionsState copyWith({
    bool? loadingInitial,
    bool? loadingMore,
    String? error,
    List<Question>? questions,
    int? skip,
    bool? hasMore,
  }) {
    return ModelQuestionsState(
      loadingInitial: loadingInitial ?? this.loadingInitial,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error,
      questions: questions ?? this.questions,
      skip: skip ?? this.skip,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ModelQuestionsCubit extends Cubit<ModelQuestionsState> {
  ModelQuestionsCubit(this.repo) : super(const ModelQuestionsState());

  final CommunityRepository repo;

  static const int _take = 15;
  int? _modelId;

  Future<void> load({required int modelId}) async {
    _modelId = modelId;

    emit(
      state.copyWith(
        loadingInitial: true,
        error: null,
        questions: const [],
        skip: 0,
        hasMore: true,
      ),
    );

    try {
      final questions = await repo.getQuestions(
        modelId: modelId,
        take: _take,
        skip: 0,
      );

      emit(
        state.copyWith(
          loadingInitial: false,
          questions: questions,
          skip: questions.length,
          hasMore: questions.length == _take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingInitial: false, error: e.toString()));
    }
  }

  Future<void> refresh() async {
    if (_modelId != null) await load(modelId: _modelId!);
  }

  Future<void> loadMore() async {
    if (_modelId == null) return;
    if (state.loadingMore || !state.hasMore) return;

    emit(state.copyWith(loadingMore: true));
    try {
      final next = await repo.getQuestions(
        modelId: _modelId!,
        take: _take,
        skip: state.skip,
      );

      emit(
        state.copyWith(
          loadingMore: false,
          questions: [...state.questions, ...next],
          skip: state.skip + next.length,
          hasMore: next.length == _take,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loadingMore: false));
    }
  }
}
