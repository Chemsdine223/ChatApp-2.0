import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constants/constants.dart';
import '../../../Network/network_services.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit() : super(DeleteUserInitial());

  Future<void> deleteAccount() async {
    emit(DeleteUserLoading());
    try {
      final response = await NetworkServices().deleteUser();
      final prefs = await SharedPreferences.getInstance();
      if (response == true) {
        prefs.remove('key');
        prefs.remove('id');
        prefs.remove('user');

        socketService.socket.dispose();
        emit(DeleteUserSuccess());
      }
    } catch (e) {
      emit(DeleteUserFailure(e.toString()));
    }
  }
}

// 65d27262bca82ee8157d32eb
