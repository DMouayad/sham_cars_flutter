import 'package:equatable/equatable.dart';
import 'package:sham_cars/features/user/models.dart';

final class AuthState extends Equatable {
  const AuthState._({this.user});
  final User? user;

  factory AuthState.authenticated(User user) {
    return AuthState._(user: user);
  }
  factory AuthState.unauthenticated() {
    return const AuthState._();
  }

  bool isUnauthenticated() => user == null;
  bool hasUser() => user != null;

  @override
  String toString() {
    return user != null
        ? 'AuthState.authenticated'
        : 'AuthState.unauthenticated';
  }

  @override
  List<Object?> get props => [user];
}
