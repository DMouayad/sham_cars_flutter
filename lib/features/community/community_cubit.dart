import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';
import 'package:sham_cars/utils/src/app_error.dart';

import 'community_repository.dart';

class CommunityState {
  final List<Question> questions;
  final List<HomeReview> reviews;
  final List<CarModel> carModels;
  final bool isLoading;
  final bool isSubmitting;
  final Object? error;
  final String? submitError;
  final String searchQuery;

  const CommunityState({
    this.questions = const [],
    this.reviews = const [],
    this.carModels = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.submitError,
    this.searchQuery = '',
  });

  CommunityState copyWith({
    List<Question>? questions,
    List<HomeReview>? reviews,
    List<CarModel>? carModels,
    bool? isLoading,
    bool? isSubmitting,
    Object? error,
    String? submitError,
    String? searchQuery,
    bool clearErrors = false,
  }) {
    return CommunityState(
      questions: questions ?? this.questions,
      reviews: reviews ?? this.reviews,
      carModels: carModels ?? this.carModels,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearErrors ? null : error,
      submitError: clearErrors ? null : submitError,
      searchQuery: searchQuery ?? this.searchQuery,
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

  List<HomeReview> get filteredReviews {
    if (searchQuery.isEmpty) return reviews;
    final q = searchQuery.toLowerCase();
    return reviews.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.body.toLowerCase().contains(q) ||
          item.userName.toLowerCase().contains(q) ||
          (item.trimSummary?.name.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  int get totalCount => questions.length + reviews.length;
}

class CommunityCubit extends Cubit<CommunityState> {
  final CommunityRepository _communityRepo;
  final CarDataRepository _carDataRepo;

  CommunityCubit(this._communityRepo, this._carDataRepo)
    : super(const CommunityState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearErrors: true));
    try {
      await RestClient.runCached(() async {
        final results = await Future.wait([
          _communityRepo.getQuestions(),
          // _fetchReviews(),
          _carDataRepo.getModels(),
        ]);

        emit(
          state.copyWith(
            questions: results[0] as List<Question>,
            // reviews: results[1] as List<HomeReview>,
            reviews: [],
            carModels: results[1] as List<CarModel>,
            isLoading: false,
          ),
        );
      });
    } catch (e) {
      emit(state.copyWith(error: e, isLoading: false));
    }
  }

  Future<List<HomeReview>> _fetchReviews() async {
    try {
      return await _communityRepo.getLatestReviews(limit: 50);
    } catch (_) {
      return [];
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  Future<bool> submitQuestion({
    required int carModelId,
    required String title,
    required String body,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearErrors: true));
    try {
      final accessToken = await GetIt.I.get<ITokensRepository>().get();
      if (accessToken == null) {
        throw AppError.unauthenticated;
      }
      await _communityRepo.postQuestion(
        carModelId: carModelId,
        title: title,
        body: body,
        accessToken: accessToken,
      );
      await load();
      return true;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, submitError: e.toString()));
      return false;
    }
  }

  Future<bool> submitReview({
    required int carTrimId,
    required int rating,
    required String comment,
    String? title,
    String? cityCode,
    required String accessToken,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearErrors: true));
    try {
      await _communityRepo.postReview(
        carTrimId: carTrimId,
        rating: rating,
        comment: comment,
        title: title,
        cityCode: cityCode,
        accessToken: accessToken,
      );
      await load();
      return true;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, submitError: e.toString()));
      return false;
    }
  }
}
