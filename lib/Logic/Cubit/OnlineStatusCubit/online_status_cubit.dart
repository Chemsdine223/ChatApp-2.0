import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'online_status_state.dart';

class OnlineStatusCubit extends Cubit<OnlineStatusState> {
  OnlineStatusCubit() : super(OnlineStatusInitial()) {
    // checkOnlineStatus();
  }

  checkOnlineStatus(bool status, List<dynamic> onlineUsers) {
    // print('----------------------------');
    emit(OnlineStatus(status, onlineUsers));
    
  }
}
