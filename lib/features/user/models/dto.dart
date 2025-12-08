import 'package:equatable/equatable.dart';
import 'package:sham_cars/features/user/models/role.dart';

abstract class BaseCompleteRegistrationDTO extends Equatable {
  final Role role;
  final String email;
  final String phoneNumber;
  final String fullName;
  final String password;

  const BaseCompleteRegistrationDTO({
    required this.role,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.password,
  });
  @override
  List<Object?> get props => [fullName, role, email, phoneNumber, password];
}

class CompletePatientRegistrationDTO extends BaseCompleteRegistrationDTO {
  const CompletePatientRegistrationDTO({
    required super.email,
    required super.phoneNumber,
    required super.fullName,
    required super.password,
  }) : super(role: Role.patient);
}

class CompletePhysicianRegistrationDTO extends BaseCompleteRegistrationDTO {
  const CompletePhysicianRegistrationDTO({
    required super.email,
    required super.phoneNumber,
    required super.fullName,
    required super.password,
    required this.biography,
    required this.location,
    required this.languages,
  }) : super(role: Role.physician);

  final String biography;
  final List<String> languages;
  final String location;

  @override
  List<Object?> get props => [...super.props, biography, languages, location];
}

class UpdateUserDTO {
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneNumberVerifiedAt;

  UpdateUserDTO({
    this.email,
    this.phoneNumber,
    this.fullName,
    this.emailVerifiedAt,
    this.phoneNumberVerifiedAt,
  });
}
