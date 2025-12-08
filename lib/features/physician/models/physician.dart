import 'package:equatable/equatable.dart';

import 'package:sham_cars/features/medical_condition/medical_condition.dart';
import 'package:sham_cars/features/medical_facility/models.dart';
import 'package:sham_cars/features/medical_procedure/medical_procedure.dart';
import 'physician_award.dart';
import 'physician_certificate.dart';
import 'physician_education.dart';
import 'physician_publication.dart';
import 'physician_shift.dart';

class Physician extends Equatable {
  final String id;
  final String name;
  final String biography;
  final String location;
  final String mobilePhoneNumber;
  final String? phoneNumber;
  final bool isMale;
  final DateTime? dateOfBirth;
  final List<String> languages;
  final List<String> specialties;
  final double rating;
  final List<MedicalCondition> treatedConditions;
  final List<MedicalProcedure> performedProcedures;
  final List<PhysicianShift> shifts;
  final List<PhysicianPublication> publications;
  final List<PhysicianCertificate> certificates;
  final List<PhysicianAward> awards;
  final List<PhysicianEducation> education;
  final List<MedicalFacility> affiliatedFacilities;

  const Physician({
    required this.id,
    required this.name,
    required this.biography,
    required this.location,
    required this.isMale,
    required this.dateOfBirth,
    required this.rating,
    required this.specialties,
    required this.mobilePhoneNumber,
    this.phoneNumber,
    this.languages = const [],
    this.treatedConditions = const [],
    this.performedProcedures = const [],
    this.shifts = const [],
    this.publications = const [],
    this.certificates = const [],
    this.awards = const [],
    this.education = const [],
    this.affiliatedFacilities = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    biography,
    isMale,
    dateOfBirth,
    languages,
    rating,
    specialties,
    mobilePhoneNumber,
    phoneNumber,
  ];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "biography": biography,
      "location": location,
      "isMale": isMale,
      "dateOfBirth": dateOfBirth?.toIso8601String(),
      "rating": rating,
      "languages": languages,
      "phoneNumber": phoneNumber,
      "mobilePhoneNumber": mobilePhoneNumber,
      "specialties": specialties,
    };
  }

  static Physician? fromJson(Map<String, dynamic> json) {
    if (json case {
      "id": String id,
      "name": String name,
      "biography": String biography,
      "location": String location,
      "mobilePhoneNumber": String mobilePhoneNumber,
      "phoneNumber": String? phoneNumber,
      "dateOfBirth": String? dateOfBirthStr,
      "isMale": bool isMale,
      "rating": double rating,
      "languages": List<String> languages,
      "specialties": List<String> specialties,
    }) {
      return Physician(
        id: id,
        name: name,
        biography: biography,
        mobilePhoneNumber: mobilePhoneNumber,
        phoneNumber: phoneNumber,
        location: location,
        rating: rating,
        languages: languages,
        specialties: specialties,
        isMale: isMale,
        dateOfBirth: dateOfBirthStr != null
            ? DateTime.tryParse(dateOfBirthStr)
            : null,
      );
    }
    return null;
  }
}
