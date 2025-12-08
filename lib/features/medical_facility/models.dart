import 'package:equatable/equatable.dart';

class MedicalFacility extends Equatable {
  final String id;
  final String name;
  final String description;
  final String location;
  final String phoneNumber;
  final String mobilePhoneNumber;
  final String? emergencyPhoneNumber;
  final double rating;

  const MedicalFacility({
    required this.id,
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.mobilePhoneNumber,
    required this.emergencyPhoneNumber,
    required this.location,
    required this.rating,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        description,
        location,
        rating,
        phoneNumber,
        emergencyPhoneNumber,
        mobilePhoneNumber
      ];
}
