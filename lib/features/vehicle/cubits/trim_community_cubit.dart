import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';

class TrimCommunityState {
  final bool loading;
  final String? error;
  final List<Review> reviews;
  final List<Question> questions;

  const TrimCommunityState({
    this.loading = false,
    this.error,
    this.reviews = const [],
    this.questions = const [],
  });

  TrimCommunityState copyWith({
    bool? loading,
    String? error,
    List<Review>? reviews,
    List<Question>? questions,
  }) {
    return TrimCommunityState(
      loading: loading ?? this.loading,
      error: error,
      reviews: reviews ?? this.reviews,
      questions: questions ?? this.questions,
    );
  }
}

class TrimCommunityCubit extends Cubit<TrimCommunityState> {
  TrimCommunityCubit(this.repo)
    : super(const TrimCommunityState(loading: true));
  final CommunityRepository repo;

  Future<void> load({required int trimId}) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final results = await Future.wait([
        repo.getReviews(trimId, take: 2, skip: 0),
        repo.getQuestions(trimId: trimId, take: 2, skip: 0),
      ]);
      emit(
        state.copyWith(
          loading: false,
          reviews: results[0] as List<Review>,
          questions: results[1] as List<Question>,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
