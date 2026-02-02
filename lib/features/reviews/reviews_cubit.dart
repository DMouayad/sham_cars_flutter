// lib/cubits/reviews_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/community/community_repository.dart';

import 'models.dart';

class ReviewsState {
  final List<Review> reviews;
  final bool isLoading;
  final bool isSubmitting;
  final Object? error;
  final String? submitError;

  const ReviewsState({
    this.reviews = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.submitError,
  });

  ReviewsState copyWith({
    List<Review>? reviews,
    bool? isLoading,
    bool? isSubmitting,
    Object? error,
    String? submitError,
    bool clearErrors = false,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearErrors ? null : error,
      submitError: clearErrors ? null : submitError,
    );
  }

  double get averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }
}

class ReviewsCubit extends Cubit<ReviewsState> {
  final CommunityRepository _repo;
  int? _carTrimId;

  ReviewsCubit(this._repo) : super(const ReviewsState());

  Future<void> load(int carTrimId) async {
    _carTrimId = carTrimId;
    emit(state.copyWith(isLoading: true, clearErrors: true));
    try {
      final reviews = await _repo.getReviews(carTrimId);
      emit(state.copyWith(reviews: reviews, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false));
    }
  }

  Future<void> refresh() async {
    if (_carTrimId != null) await load(_carTrimId!);
  }

  Future<bool> submitReview({
    required int rating,
    required String comment,
    String? title,
    String? cityCode,
    required String accessToken,
  }) async {
    if (_carTrimId == null) return false;

    emit(state.copyWith(isSubmitting: true, clearErrors: true));
    try {
      await _repo.postReview(
        carTrimId: _carTrimId!,
        rating: rating,
        comment: comment,
        title: title,
        cityCode: cityCode,
        accessToken: accessToken,
      );
      await refresh();
      return true;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, submitError: e.toString()));
      return false;
    }
  }
}
