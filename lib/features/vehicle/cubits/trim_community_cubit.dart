import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';

class TrimCommunityState {
  final bool loadingInitial;
  final String? error;

  final List<Review> reviews;
  final List<Question> questions;

  final bool loadingMoreReviews;
  final bool loadingMoreQuestions;

  final bool hasMoreReviews;
  final bool hasMoreQuestions;

  final int reviewsSkip;
  final int questionsSkip;

  const TrimCommunityState({
    this.loadingInitial = false,
    this.error,
    this.reviews = const [],
    this.questions = const [],
    this.loadingMoreReviews = false,
    this.loadingMoreQuestions = false,
    this.hasMoreReviews = true,
    this.hasMoreQuestions = true,
    this.reviewsSkip = 0,
    this.questionsSkip = 0,
  });

  TrimCommunityState copyWith({
    bool? loadingInitial,
    String? error,
    List<Review>? reviews,
    List<Question>? questions,
    bool? loadingMoreReviews,
    bool? loadingMoreQuestions,
    bool? hasMoreReviews,
    bool? hasMoreQuestions,
    int? reviewsSkip,
    int? questionsSkip,
  }) {
    return TrimCommunityState(
      loadingInitial: loadingInitial ?? this.loadingInitial,
      error: error,
      reviews: reviews ?? this.reviews,
      questions: questions ?? this.questions,
      loadingMoreReviews: loadingMoreReviews ?? this.loadingMoreReviews,
      loadingMoreQuestions: loadingMoreQuestions ?? this.loadingMoreQuestions,
      hasMoreReviews: hasMoreReviews ?? this.hasMoreReviews,
      hasMoreQuestions: hasMoreQuestions ?? this.hasMoreQuestions,
      reviewsSkip: reviewsSkip ?? this.reviewsSkip,
      questionsSkip: questionsSkip ?? this.questionsSkip,
    );
  }
}

class TrimCommunityCubit extends Cubit<TrimCommunityState> {
  TrimCommunityCubit(this.repo) : super(const TrimCommunityState());

  final CommunityRepository repo;

  static const int _take = 15;
  int? _trimId;

  Future<void> load({required int trimId}) async {
    _trimId = trimId;

    emit(
      state.copyWith(
        loadingInitial: true,
        error: null,
        reviews: const [],
        questions: const [],
        reviewsSkip: 0,
        questionsSkip: 0,
        hasMoreReviews: true,
        hasMoreQuestions: true,
      ),
    );

    try {
      final results = await Future.wait([
        repo.getReviews(trimId, take: _take, skip: 0),
        repo.getQuestions(trimId: trimId, take: _take, skip: 0),
      ]);

      final reviews = results[0] as List<Review>;
      final questions = results[1] as List<Question>;

      emit(
        state.copyWith(
          loadingInitial: false,
          reviews: reviews,
          questions: questions,
          reviewsSkip: reviews.length,
          questionsSkip: questions.length,
          hasMoreReviews: reviews.length == _take,
          hasMoreQuestions: questions.length == _take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingInitial: false, error: e.toString()));
    }
  }

  Future<void> refreshAll() async {
    if (_trimId != null) await load(trimId: _trimId!);
  }

  Future<void> loadMoreReviews() async {
    if (_trimId == null) return;
    if (state.loadingMoreReviews || !state.hasMoreReviews) return;

    emit(state.copyWith(loadingMoreReviews: true));

    try {
      final next = await repo.getReviews(
        _trimId!,
        take: _take,
        skip: state.reviewsSkip,
      );

      emit(
        state.copyWith(
          loadingMoreReviews: false,
          reviews: [...state.reviews, ...next],
          reviewsSkip: state.reviewsSkip + next.length,
          hasMoreReviews: next.length == _take,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loadingMoreReviews: false));
    }
  }

  Future<void> loadMoreQuestions() async {
    if (_trimId == null) return;
    if (state.loadingMoreQuestions || !state.hasMoreQuestions) return;

    emit(state.copyWith(loadingMoreQuestions: true));

    try {
      final next = await repo.getQuestions(
        trimId: _trimId!,
        take: _take,
        skip: state.questionsSkip,
      );

      emit(
        state.copyWith(
          loadingMoreQuestions: false,
          questions: [...state.questions, ...next],
          questionsSkip: state.questionsSkip + next.length,
          hasMoreQuestions: next.length == _take,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loadingMoreQuestions: false));
    }
  }
}
