// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'home_repository.dart';
// import 'mock_home_repository.dart';
// import 'models.dart';

// final homeRepositoryProvider = Provider<HomeRepository>((ref) {
//   return MockHomeRepository(); // later switch to ApiHomeRepository()
// });

// final homeFeedProvider = FutureProvider<HomeFeed>((ref) async {
//   final repo = ref.watch(homeRepositoryProvider);
//   return repo.fetchHomeFeed();
// });
