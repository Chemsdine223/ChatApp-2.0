import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Logic/Models/user.dart';
import 'package:chat_app/Logic/Network/network_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    getUser();
  }

  Future getUser() async {
    emit(AuthLoading());
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
  ) async {
    emit(AuthLoading());
    try {
      final response = await NetworkServices()
          .register(username, firstname, lastname, phone);

      emit(RegisteredUser(response));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void disconnect() {
    emit(Disconnected());
  }
}
