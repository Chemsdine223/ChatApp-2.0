part of 'registration_form_cubit.dart';

sealed class RegistrationFormState extends Equatable {
  const RegistrationFormState();

  @override
  List<Object> get props => [];
}

final class RegistrationFormInitial extends RegistrationFormState {}

final class RegistrationFormStepTwo extends RegistrationFormState {
  final String firstname;
  final String lastname;
  final String phone;
  final String username;
  

  const RegistrationFormStepTwo(
      this.firstname, this.lastname, this.phone, this.username);

  @override
  List<Object> get props => [firstname, lastname, phone, username];
}
