part of 'delete_user_cubit.dart';

sealed class DeleteUserState extends Equatable {
  const DeleteUserState();

  @override
  List<Object> get props => [];
}

final class DeleteUserInitial extends DeleteUserState {}

final class DeleteUserLoading extends DeleteUserState {}

final class DeleteUserSuccess extends DeleteUserState {}

final class DeleteUserFailure extends DeleteUserState {
  final String errorMessage;

  const DeleteUserFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
