import 'dart:async';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/medical_facility/models.dart';
import 'package:sham_cars/features/physician/models/physician.dart';
import 'package:sham_cars/features/search/models/search_filters.dart';
import 'package:sham_cars/features/search/models/search_result.dart';

part './repos/search_repository.dart';
part 'repos/api_search_repository.dart';
part 'repos/fake_search_repository.dart';
