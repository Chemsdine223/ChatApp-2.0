part of 'auth_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class NewUser extends AuthenticationState {}


final class Disconnected extends AuthenticationState {}

final class RegisteredUser extends AuthenticationState {
  final UserModel user;

  const RegisteredUser(this.user);

  @override
  List<Object> get props => [user];
}

final class AuthenticationError extends AuthenticationState {
  final String errorMessage;

  const AuthenticationError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
