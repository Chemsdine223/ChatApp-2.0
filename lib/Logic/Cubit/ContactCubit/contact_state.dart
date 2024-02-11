part of 'contact_cubit.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

final class ContactInitial extends ContactState {}

final class ContactLoaded extends ContactState {
  final List<Contact> contacts;

  const ContactLoaded({required this.contacts});

  @override
  List<Object> get props => [contacts];
}

final class ContactLoading extends ContactState {}

final class ContactError extends ContactState {
  final String errorMsg;

  const ContactError({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
