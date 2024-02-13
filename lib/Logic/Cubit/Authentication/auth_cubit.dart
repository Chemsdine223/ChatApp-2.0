import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Logic/Models/user.dart';
import 'package:chat_app/Logic/Network/network_services.dart';

part 'auth_cubit_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial()) {
    getUser();
  }

  Future getUser() async {
    emit(AuthenticationLoading());
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final storedUser = preferences.getString('user');

    print(storedUser);

    // print(storedUser);
    if (storedUser == null) {
      emit(NewUser());
    } else {
      final json = jsonDecode(storedUser);
      final model = UserModel.fromJson(json['user']);
      emit(RegisteredUser(model));
    }
  }

  Future register(
    String username,
    String firstname,
    String lastname,
    String phone,
    XFile? avatar,
  ) async {
    emit(AuthenticationLoading());
    try {
      final String avatarUrl = await NetworkServices().uploadAvatar(avatar);
      final response = await NetworkServices().register(
        username,
        firstname,
        lastname,
        phone,
        avatarUrl,
      );

      emit(RegisteredUser(response));
    } catch (e) {
      emit(
        AuthenticationError(
          e.toString(),
        ),
      );
    }
  }

  void resetInCaseOfError() {
    emit(NewUser());
  }

  void disconnect() {
    emit(Disconnected());
  }
}
