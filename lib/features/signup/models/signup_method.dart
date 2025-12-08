enum SignupMethod {
  email,
  phone;

  static SignupMethod? byNameOrNull(String name) {
    try {
      return SignupMethod.values.byName(name);
    } catch (_) {
      return null;
    }
  }

  bool get isEmail => this == SignupMethod.email;
  bool get isPhone => this == SignupMethod.phone;
}
