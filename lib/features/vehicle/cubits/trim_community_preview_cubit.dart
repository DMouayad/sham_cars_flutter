import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/common/data_state.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/user_profile/repositories/user_activity_repository.dart';

class TrimCommunityPreview {
  final Review? myReview;
  final List<Question> myQuestions;
  final List<Review> reviews;
  final List<Question> questions;

  const TrimCommunityPreview({
    required this.myReview,
    required this.myQuestions,
    required this.reviews,
    required this.questions,
  });

  Question? get myLatestQuestion =>
      myQuestions.isEmpty ? null : myQuestions.first;
  int get myQuestionsCount => myQuestions.length;
}

class TrimCommunityPreviewCubit extends Cubit<DataState<TrimCommunityPreview>> {
  TrimCommunityPreviewCubit(this._communityRepo, this._activityRepo)
    : super(const DataInitial()) {
    _auth = GetIt.I<AuthNotifier>();
    _wasLoggedIn = _auth.isLoggedIn;
    _authListener = () {
      final isLoggedIn = _auth.isLoggedIn;
      // Only reload when user just logged in
      if (!_wasLoggedIn && isLoggedIn && _trimId != null) {
        log('Auth changed -> reloading preview for trim=$_trimId');
        load(trimId: _trimId!);
      }
      _wasLoggedIn = isLoggedIn;
    };
    _auth.addListener(_authListener);
  }

  final CommunityRepository _communityRepo;
  final UserActivityRepository _activityRepo;

  late final AuthNotifier _auth;
  late final void Function() _authListener;
  late bool _wasLoggedIn;

  int? _trimId;
  static const int _previewTake = 4;
  static const int _myLimit = 50;

  Future<void> load({required int trimId}) async {
    emit(const DataLoading());
    _trimId = trimId;

    try {
      // 1) Always try to load community preview (this should not depend on "my" endpoints)
      final communityResults = await Future.wait([
        _communityRepo.getReviews(trimId: trimId, take: _previewTake),
        _communityRepo.getQuestions(trimId: trimId, take: _previewTake),
      ]);

      final communityReviews = communityResults[0] as List<Review>;
      final communityQuestions = communityResults[1] as List<Question>;

      // 2) Best-effort: try to load "my" content (ignore failures)
      Review? myReview;
      List<Question> myQuestions = const [];

      try {
        final token = await GetIt.I<ITokensRepository>().get();
        if (token != null) {
          final myResults = await Future.wait([
            _findMyLatestReviewForTrim(trimId, token),
            _findMyQuestionsForTrim(trimId, token),
          ]);
          myReview = myResults[0] as Review?;
          myQuestions = myResults[1] as List<Question>;
        }
      } catch (e, st) {
        // Don't fail the whole section; just log for debugging
        log(
          'TrimCommunityPreviewCubit: failed to load my content',
          error: e,
          stackTrace: st,
        );
      }

      final myReviewId = myReview?.id;
      final myQuestionIds = myQuestions.map((q) => q.id).toSet();

      // Exclude duplicates and shrink to 2
      final reviewsOthers = communityReviews
          .where((r) => myReviewId == null || r.id != myReviewId)
          .take(3)
          .toList();

      final questionsOthers = communityQuestions
          .where((q) => !myQuestionIds.contains(q.id))
          .take(3)
          .toList();

      emit(
        DataLoaded(
          TrimCommunityPreview(
            myReview: myReview,
            myQuestions: myQuestions,
            reviews: reviewsOthers,
            questions: questionsOthers,
          ),
        ),
      );
    } catch (e, st) {
      log(
        'TrimCommunityPreviewCubit: failed to load community preview',
        error: e,
        stackTrace: st,
      );
      emit(DataError(e.toString()));
    }
  }

  Future<Review?> _findMyLatestReviewForTrim(int trimId, String token) async {
    Review? latest;

    final items = await _activityRepo.getMyReviews(
      accessToken: token,
      limit: _myLimit,
      skip: 0,
    );

    for (final r in items) {
      // IMPORTANT: confirm the field name you have in Review model:
      // trimId vs carTrimId. If it's wrong, this will never match.
      if (r.trimId == trimId) {
        final rDt = r.createdAt;
        final latestDt = latest?.createdAt;

        if (latest == null) {
          latest = r;
        } else if (latestDt != null && rDt.isAfter(latestDt)) {
          latest = r;
        } else if (latestDt == null) {
          latest = r;
        }
      }
    }

    return latest;
  }

  Future<List<Question>> _findMyQuestionsForTrim(
    int trimId,
    String token,
  ) async {
    final matches = <Question>[];

    final items = await _activityRepo.getMyQuestions(
      accessToken: token,
      limit: _myLimit,
      skip: 0,
    );

    for (final q in items) {
      if (q.trimId == trimId || q.modelId == trimId) matches.add(q);
    }

    // Latest first (safe even if createdAt is nullable)
    matches.sort((a, b) {
      final adt = a.createdAt;
      final bdt = b.createdAt;
      return bdt.compareTo(adt);
    });

    return matches;
  }

  @override
  Future<void> close() {
    _auth.removeListener(_authListener);
    return super.close();
  }
}
