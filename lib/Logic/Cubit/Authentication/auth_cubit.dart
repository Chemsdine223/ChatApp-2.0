import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/Constants/constants.dart';
import 'package:chat_app/Network/firebase_storage_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_app/Network/network_services.dart';
import 'package:chat_app/Models/user.dart';

part 'auth_cubit_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial()) {
    getUser();
  }

  Future getUser() async {
    emit(AuthenticationLoading());
    await Future.delayed(const Duration(seconds: 2));

    // ref.watch(providerOfSocket);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final storedUser = preferences.getString('user');

    // print(storedUser);

    // print(storedUser);
    if (storedUser == null) {
      emit(NewUser());
    } else {
      final json = jsonDecode(storedUser);
      final model = UserModel.fromJson(json['user']);
      // print(providerOfSocket);
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
      logger.f('response: $response');
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

  void editProfilePhoto(File imageFile, BuildContext context) async {
    emit(AuthenticationLoading());

    await Future.delayed(const Duration(seconds: 2));

    // log('Phone request: $phone');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final storedUser = preferences.getString('user');

    final json = jsonDecode(storedUser!);
    final user = UserModel.fromJson(json['user']);

    try {
      final response = await NetworkServices().editPhoto(imageFile);
      logger.f('response: $response');
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
    File file,
  ) async {
    emit(AuthenticationLoading());
    await Future.delayed(const Duration(seconds: 5));
    try {
      final avatar = await FirebaseStorageService.uploadImageToFirebase(
          file, DateTime.now().toString());
      final response = await NetworkServices().register(
        username,
        firstname,
        lastname,
        phone,
        avatar,
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
