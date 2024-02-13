import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'registration_form_state.dart';

class RegistrationFormCubit extends Cubit<RegistrationFormState> {
  RegistrationFormCubit() : super(RegistrationFormInitial());

  stepTwo(
    String firstname,
    String lastname,
    String phone,
    String username,
  ) {
    emit(RegistrationFormStepTwo(firstname, lastname, phone, username));
  }

  stepOne() {
    emit(RegistrationFormInitial());
  }
}
