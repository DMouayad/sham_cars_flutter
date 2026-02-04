import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/common/data_state.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/community/community_repository.dart';

class TrimCommunityPreview {
  final List<Review> reviews;
  final List<Question> questions;

  const TrimCommunityPreview({required this.reviews, required this.questions});
}

class TrimCommunityPreviewCubit extends Cubit<DataState<TrimCommunityPreview>> {
  TrimCommunityPreviewCubit(this._repo) : super(const DataInitial());

  final CommunityRepository _repo;

  Future<void> load({required int trimId}) async {
    emit(const DataLoading());

    try {
      final results = await Future.wait([
        _repo.getReviews(trimId: trimId, take: 2),
        _repo.getQuestions(trimId: trimId, take: 2), // temporarily
      ]);

      final reviews = (results[0] as List<Review>).take(2).toList();
      final questions = (results[1] as List<Question>).take(2).toList();

      emit(
        DataLoaded(
          TrimCommunityPreview(reviews: reviews, questions: questions),
        ),
      );
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }
}
