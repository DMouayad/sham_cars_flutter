enum Role {
  user;

  static Role byNameOrThrow(String name) {
    try {
      return Role.values.byName(name);
    } catch (_) {
      throw Exception("Role not found!");
    }
  }

  static Role? byNameOrNull(String name) {
    try {
      return Role.values.byName(name);
    } catch (_) {
      return null;
    }
  }
}
