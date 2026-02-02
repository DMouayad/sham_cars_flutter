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
