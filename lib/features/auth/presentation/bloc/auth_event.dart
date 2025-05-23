part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  AuthSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}

final class AuthLogInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLogInEvent({
    required this.email,
    required this.password,
  });
}

final class AuthGetUserDetailsEvent extends AuthEvent {}

final class AuthLogOutEvent extends AuthEvent {}

final class GetAllUsersEvent extends AuthEvent {}

final class MakeCoachEvent extends AuthEvent {
  final String userId;
  final String teamName;
  final File teamLogo;

  MakeCoachEvent({
    required this.userId,
    required this.teamName,
    required this.teamLogo,
  });
}

final class MakePlayerEvent extends AuthEvent {
  final String userId;
  final String teamId;

  MakePlayerEvent({
    required this.userId,
    required this.teamId,
  });
}

final class MakeRegularUserEvent extends AuthEvent {
  final String userId;

  MakeRegularUserEvent({
    required this.userId,
  });
}