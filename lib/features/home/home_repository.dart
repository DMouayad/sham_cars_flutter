import 'dart:async';

import 'package:sham_cars/api/cache.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/community/community_repository.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/vehicle/models.dart';
import 'package:sham_cars/features/vehicle/repositories/car_data_repository.dart';

import 'models.dart';

class HomeRepository {
  final ResponseCache _cache;
  final CarDataRepository _carDataRepo;
  final CommunityRepository _communityRepo;
  Completer<HomeData>? _completer;

  static const _cacheKeyHome = 'home_data';

  HomeRepository(this._cache, this._carDataRepo, this._communityRepo);

  Future<HomeData> getHomeData({bool forceRefresh = false}) async {
    if (_completer != null && !forceRefresh) {
      return _completer!.future;
    }
    _completer = Completer<HomeData>();
    final completer = _completer!;

    // When the future completes, reset the completer.
    completer.future.whenComplete(() {
      if (identical(completer, _completer)) {
        _completer = null;
      }
    });

    try {
      if (!forceRefresh) {
        if (_cache.get<HomeData>(_cacheKeyHome) case final cached?) {
          completer.complete(cached);
          return completer.future;
        }
      }

      final data = await RestClient.runCached(() async {
        final results = await Future.wait([
          _carDataRepo.getTrendingCars(take: 10, skip: 0),
          _carDataRepo.getHotTopics(take: 10, skip: 0),
          _communityRepo.getLatestQuestions(),
          _communityRepo.getLatestReviews(),
        ]);

        final homeData = HomeData(
          trendingTrims: results[0] as List<CarTrimSummary>,
          hotTopics: results[1] as List<HotTopic>,
          latestQuestions: results[2] as List<Question>,
          latestReviews: results[3] as List<Review>,
        );

        _cache.set(_cacheKeyHome, homeData, ttl: const Duration(minutes: 5));
        return homeData;
      });
      completer.complete(data);
    } catch (e, s) {
      if (!completer.isCompleted) {
        completer.completeError(e, s);
      }
    }

    return completer.future;
  }

  /// Search across trims
  Future<List<CarTrimSummary>> search(String query) async {
    if (query.trim().isEmpty) return [];
    return _carDataRepo.searchTrims(query);
  }

  void invalidateCache() {
    _cache.invalidate(_cacheKeyHome);
  }
}
