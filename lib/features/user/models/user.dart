import 'package:equatable/equatable.dart';
import 'package:sham_cars/api/rest_client.dart';

import 'role.dart';

class User extends Equatable {
  final String? id;
  final Role role;
  final bool activated;
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneNumberVerifiedAt;
  final DateTime? identityConfirmedAt;
  final DateTime? createdAt;

  const User({
    this.id,
    required this.role,
    required this.activated,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.emailVerifiedAt,
    required this.phoneNumberVerifiedAt,
    required this.createdAt,
    required this.identityConfirmedAt,
  });
  static User? fromJsonObj(JsonObject json) {
    if (json case {
      'activated': bool activated,
      'email': String? email,
      'emailVerifiedAt': String? emailVerifiedAt,
      'phoneNumber': String? phoneNumber,
      'phoneNumberVerifiedAt': String? phoneNumberVerifiedAt,
      'identityConfirmedAt': String? identityConfirmedAt,
      'createdAt': String createdAt,
      'role': String role,
    }) {
      return User(
        activated: activated,
        role: Role.byNameOrThrow(role),
        email: email,
        phoneNumber: phoneNumber,
        fullName: null,
        createdAt: DateTime.tryParse(createdAt),
        emailVerifiedAt: DateTime.tryParse(emailVerifiedAt ?? ''),
        phoneNumberVerifiedAt: DateTime.tryParse(phoneNumberVerifiedAt ?? ''),
        identityConfirmedAt: DateTime.tryParse(identityConfirmedAt ?? ''),
      );
    }
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    role,
    activated,
    email,
    phoneNumber,
    fullName,
    emailVerifiedAt,
    phoneNumberVerifiedAt,
    identityConfirmedAt,
    createdAt,
  ];
  JsonObject toJson() => {
    'id': id,
    'role': role.name,
    'activated': activated,
    'email': email,
    'phoneNumber': phoneNumber,
    'fullName': fullName,
    'emailVerifiedAt': emailVerifiedAt?.toIso8601String(),
    'phoneNumberVerifiedAt': phoneNumberVerifiedAt?.toIso8601String(),
    'identityConfirmedAt': identityConfirmedAt?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
  };
}
