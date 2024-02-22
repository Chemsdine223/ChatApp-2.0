import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_app/Logic/Network/network_services.dart';
import 'package:chat_app/Models/user.dart';
import 'package:chat_app/Providers/provider.dart';

part 'auth_cubit_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  WidgetRef ref;
  AuthenticationCubit(
    this.ref,
  ) : super(AuthenticationInitial()) {
    getUser();
  }

  Future getUser() async {
    emit(AuthenticationLoading());
    await Future.delayed(const Duration(seconds: 2));

    ref.watch(providerOfSocket);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final storedUser = preferences.getString('user');

    print(storedUser);

    // print(storedUser);
    if (storedUser == null) {
      emit(NewUser());
    } else {
      final json = jsonDecode(storedUser);
      final model = UserModel.fromJson(json['user']);
      print(providerOfSocket);
      emit(RegisteredUser(model));
    }
  }

  void deleteAccount() {
    emit(LoggedOut());
  }

  void editPhoneNumber(String phone, BuildContext context) async {
    emit(AuthenticationLoading());

    await Future.delayed(const Duration(seconds: 2));

    log('Phone request: $phone');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final storedUser = preferences.getString('user');

    final json = jsonDecode(storedUser!);
    final user = UserModel.fromJson(json['user']);

    try {
      final response = await NetworkServices().editPhone(phone);
      log('Success response ${response.firstname}');

      emit(RegisteredUser(response));
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully updated')));
      }
    } catch (e) {
      log(e.toString());
      emit(RegisteredUser(user));
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> editPhoto(String url, XFile? newAvatar) async {
    emit(AuthenticationLoading());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final storedUser = preferences.getString('user');
    final json = jsonDecode(storedUser!);
    final model = UserModel.fromJson(json['user']);
    print('before try');
    try {
      final newPhoto = await NetworkServices().editAvatar(newAvatar, url);
      model.avatar = newPhoto;

      preferences.setString('user', model.toString());

      emit(RegisteredUser(model));

      // model.avatar = newAvatar.
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  // bool closed = false;

  // @override
  // Future<void> close() {
  //   closed = true;
  //   return super.close();
  // }

  @override
  void emit(AuthenticationState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future register(
    String username,
    String firstname,
    String lastname,
    String phone,
    // WidgetRef ref,
    // XFile? avatar,
  ) async {
    emit(AuthenticationLoading());
    try {
      // final String avatarUrl = await NetworkServices().uploadAvatar(avatar);
      final response = await NetworkServices().register(
        username,
        firstname,
        lastname,
        phone,
        // avatarUrl,
        // 'avatarUrl',
      );

      ref.watch(providerOfSocket);

      emit(RegisteredUser(response));
      print(response);
      // ref.watch(providerOfSocket);
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
