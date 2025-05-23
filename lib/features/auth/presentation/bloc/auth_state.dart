part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

final class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess(this.user);
}

final class UsersLoaded extends AuthState {
  final List<UserEntity> users;

  UsersLoaded(this.users);
}
