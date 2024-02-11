part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class NewUser extends AuthState {}

final class Disconnected extends AuthState {}

final class RegisteredUser extends AuthState {
  final UserModel user;

  const RegisteredUser(this.user);

  @override
  List<Object> get props => [user];
}

final class AuthError extends AuthState {
  final String errorMessage;

  const AuthError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
