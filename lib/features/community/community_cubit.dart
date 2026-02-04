import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';

import 'community_repository.dart';

class CommunityState {
  final List<Question> questions;
  final List<Review> reviews;

  final bool isLoading;
  final bool isSubmitting;

  final bool isLoadingMoreQuestions;
  final bool hasMoreQuestions;
  final int questionsSkip;

  final bool isLoadingMoreReviews;
  final bool hasMoreReviews;
  final int reviewsSkip;

  final Object? error;
  final String? submitError;
  final String searchQuery;

  const CommunityState({
    this.questions = const [],
    this.reviews = const [],
    this.isLoading = false,
    this.isSubmitting = false,

    this.isLoadingMoreQuestions = false,
    this.hasMoreQuestions = true,
    this.questionsSkip = 0,
    this.isLoadingMoreReviews = false,
    this.hasMoreReviews = true,
    this.reviewsSkip = 0,
    this.error,
    this.submitError,
    this.searchQuery = '',
  });

  CommunityState copyWith({
    List<Question>? questions,
    List<Review>? reviews,
    bool? isLoading,
    bool? isSubmitting,
    bool? isLoadingMoreQuestions,
    bool? hasMoreQuestions,
    int? questionsSkip,
    bool? hasMoreReviews,
    bool? isLoadingMoreReviews,
    int? reviewsSkip,
    Object? error,
    String? submitError,
    String? searchQuery,
    bool clearErrors = false,
  }) {
    return CommunityState(
      questions: questions ?? this.questions,
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingMoreQuestions:
          isLoadingMoreQuestions ?? this.isLoadingMoreQuestions,
      hasMoreQuestions: hasMoreQuestions ?? this.hasMoreQuestions,
      questionsSkip: questionsSkip ?? this.questionsSkip,
      error: clearErrors ? null : (error ?? this.error),
      submitError: clearErrors ? null : (submitError ?? this.submitError),
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMoreReviews: isLoadingMoreReviews ?? this.isLoadingMoreReviews,
      hasMoreReviews: hasMoreReviews ?? this.hasMoreReviews,
      reviewsSkip: reviewsSkip ?? this.reviewsSkip,
    );
  }

  List<Question> get filteredQuestions {
    if (searchQuery.isEmpty) return questions;
    final q = searchQuery.toLowerCase();
    return questions.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.body.toLowerCase().contains(q) ||
          item.userName.toLowerCase().contains(q);
    }).toList();
  }

  List<Review> get filteredReviews {
    if (searchQuery.isEmpty) return reviews;
    final q = searchQuery.toLowerCase();
    return reviews.where((item) {
      return (item.title?.toLowerCase().contains(q) ?? false) ||
          item.body.toLowerCase().contains(q) ||
          item.userName.toLowerCase().contains(q) ||
          (item.trimName?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  int get totalCount => questions.length + reviews.length;
}

class CommunityCubit extends Cubit<CommunityState> {
  final CommunityRepository _communityRepo;

  CommunityCubit(this._communityRepo) : super(const CommunityState());

  static const int _take = 15;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearErrors: true));

    try {
      final results = await Future.wait([
        _communityRepo.getQuestions(take: _take, skip: 0),
        _communityRepo.getReviews(take: _take, skip: 0),
      ]);

      final questions = results[0] as List<Question>;
      final reviews = results[1] as List<Review>;

      emit(
        state.copyWith(
          isLoading: false,
          questions: questions,
          reviews: reviews,

          // questions paging
          questionsSkip: questions.length,
          hasMoreQuestions: questions.length == _take,
          isLoadingMoreQuestions: false,

          // reviews paging
          reviewsSkip: reviews.length,
          hasMoreReviews: reviews.length == _take,
          isLoadingMoreReviews: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false));
    }
  }

  Future<void> loadMoreQuestions() async {
    if (state.searchQuery.isNotEmpty) return;
    if (state.isLoadingMoreQuestions || !state.hasMoreQuestions) return;

    emit(state.copyWith(isLoadingMoreQuestions: true));

    try {
      final next = await _communityRepo.getQuestions(
        take: _take,
        skip: state.questionsSkip,
      );

      emit(
        state.copyWith(
          isLoadingMoreQuestions: false,
          questions: [...state.questions, ...next],
          questionsSkip: state.questionsSkip + next.length,
          hasMoreQuestions: next.length == _take,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMoreQuestions: false));
    }
  }

  Future<void> loadMoreReviews() async {
    if (state.searchQuery.isNotEmpty) return;
    if (state.isLoadingMoreReviews || !state.hasMoreReviews) return;

    emit(state.copyWith(isLoadingMoreReviews: true));

    try {
      final next = await _communityRepo.getReviews(
        take: _take,
        skip: state.reviewsSkip,
      );

      emit(
        state.copyWith(
          isLoadingMoreReviews: false,
          reviews: [...state.reviews, ...next],
          reviewsSkip: state.reviewsSkip + next.length,
          hasMoreReviews: next.length == _take,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMoreReviews: false));
    }
  }

  void search(String query) => emit(state.copyWith(searchQuery: query));
}
