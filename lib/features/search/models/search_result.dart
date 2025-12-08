import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:sham_cars/features/medical_facility/models.dart';
import 'package:sham_cars/features/physician/models/physician.dart';
import 'package:sham_cars/utils/src/constants.dart';

typedef SearchResults = Future<List<SearchResult>>;

enum SearchResultCategory { physician, facility }

sealed class SearchResult<T> extends Equatable {
  final T item;
  final String title;
  final String subTitle;
  final String location;
  final double stars;
  final String avatarImgUrl;
  final SearchResultCategory category;

  const SearchResult({
    required this.item,
    required this.category,
    required this.title,
    required this.subTitle,
    required this.location,
    required this.stars,
    required this.avatarImgUrl,
  });
  bool get isPhysician => category == SearchResultCategory.physician;
  static SearchResult<Physician> physician(Physician physician) {
    return PhysicianSearchResult._(physician);
  }

  static SearchResult<MedicalFacility> facility(MedicalFacility facility) {
    return MedicalFacilitySearchResult._(facility);
  }

  static SearchResult<MedicalFacility> fakeMedFacility() {
    return MedicalFacilitySearchResult._(
      MedicalFacility(
        emergencyPhoneNumber: faker.phoneNumber.us(),
        mobilePhoneNumber: faker.phoneNumber.us(),
        phoneNumber: faker.phoneNumber.us(),
        id: faker.guid.guid(),
        name: faker.company.name(),
        description: faker.lorem.sentence(),
        location: faker.address.streetAddress(),
        rating: faker.randomGenerator.decimal(),
      ),
    );
  }

  @override
  List<Object?> get props => [
    item,
    title,
    category,
    subTitle,
    location,
    stars,
    avatarImgUrl,
  ];
}

class MedicalFacilitySearchResult extends SearchResult<MedicalFacility> {
  final MedicalFacility facility;
  MedicalFacilitySearchResult._(this.facility)
    : super(
        item: facility,
        category: SearchResultCategory.facility,
        title: facility.name,
        subTitle: facility.description,
        location: facility.location,
        stars: facility.rating,
        avatarImgUrl: kDefaultMedicalFacilityAvatarUrl,
      );
}

class PhysicianSearchResult extends SearchResult<Physician> {
  final Physician physician;
  PhysicianSearchResult._(this.physician)
    : super(
        item: physician,
        category: SearchResultCategory.physician,
        title: physician.name,
        subTitle: physician.specialties.join(", "),
        location: physician.location,
        stars: physician.rating,
        avatarImgUrl: physician.isMale
            ? kMalePhysicianAvatarUrl
            : kFemalePhysicianAvatarUrl,
      );
}
