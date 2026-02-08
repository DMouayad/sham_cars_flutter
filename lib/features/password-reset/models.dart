class PasswordResetSession {
  final String token;
  final DateTime? expiresAt;
  PasswordResetSession(this.token, this.expiresAt);

  bool get isExpired => expiresAt == null || DateTime.now().isAfter(expiresAt!);
}
