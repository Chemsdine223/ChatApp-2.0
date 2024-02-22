import 'package:bloc/bloc.dart';
import 'package:chat_app/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/network_services.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit() : super(DeleteUserInitial());

  Future<void> deleteAccount() async {
    emit(DeleteUserLoading());
    try {
      // SocketService().initConnection();
      final response = await NetworkServices().deleteUser();
      final prefs = await SharedPreferences.getInstance();
      // prefs.remove('user');

      // prefs.clear();

      if (response == true) {
        prefs.remove('key');
        prefs.remove('id');
        prefs.remove('user');
        // await prefs.reload();

        socketService.socket.dispose();

        // socketService.socket.clearListeners();

        // socketService.socket.close();

        emit(DeleteUserSuccess());
      }
    } catch (e) {
      emit(DeleteUserFailure(e.toString()));
    }
  }
}

// 65d27262bca82ee8157d32eb
