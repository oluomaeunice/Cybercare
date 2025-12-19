part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUp({required this.name, required this.email, required this.password});
}


final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({required this.email, required this.password});
}

final class AuthIsUserLoggedIn extends AuthEvent {
}
final class AuthLogout extends AuthEvent {}
final class AuthUpdateProfile extends AuthEvent {
  final String userId;
  final String name;
  final File? image;
  AuthUpdateProfile({required this.userId, required this.name, this.image});
}

final class AuthForgotPassword extends AuthEvent {
  final String email;
  AuthForgotPassword({required this.email});
}