import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'registration_form_state.dart';

class RegistrationFormCubit extends Cubit<FormData> {
  RegistrationFormCubit() : super(FormData());

  nextStep(
    String firstname,
    String lastname,
    String phone,
    String username,
  ) {
    emit(state.copyWith(
      firstname: firstname,
      lastname: lastname,
      phone: phone,
      username: username,
      step: 1,
    ));
  }

  previousStep(
    String firstname,
    String lastname,
    String phone,
    String username,
  ) {
    emit(state.copyWith(step: 0));
  }
}
