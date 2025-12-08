import 'package:faker/faker.dart';

import 'role.dart';
import 'user.dart';

class UserBuilder {
  const UserBuilder();

  // Method to build the User object
  User build({
    String? id,
    Role role = Role.guest,
    bool activated = true,
    String? email,
    String? phoneNumber,
    String? fullName,
    DateTime? emailVerifiedAt,
    DateTime? phoneNumberVerifiedAt,
    DateTime? identityConfirmedAt,
    DateTime? createdAt,
  }) {
    final faker = Faker();

    return User(
      id: id ?? faker.guid.guid(),
      role: role,
      activated: activated,
      email: email ?? faker.internet.email(),
      phoneNumber: phoneNumber ?? faker.phoneNumber.us(),
      fullName: fullName ?? faker.person.name(),
      emailVerifiedAt: emailVerifiedAt,
      phoneNumberVerifiedAt: phoneNumberVerifiedAt,
      identityConfirmedAt: identityConfirmedAt,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  DateTime getRandomDate(Faker faker) {
    return faker.date.dateTimeBetween(
      DateTime.now().subtract(const Duration(days: 365)),
      DateTime.now(),
    );
  }
}
