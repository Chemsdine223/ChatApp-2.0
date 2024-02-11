import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'online_status_state.dart';

class OnlineStatusCubit extends Cubit<OnlineStatusState> {
  final String userId;
  OnlineStatusCubit(
    this.userId,
  ) : super(OnlineStatusInitial()) {
    // checkOnlineStatus();
  }

  // checkOnlineStatus() {
  //   // final status = SocketService().checkStatus(userId);
  //   // log('${status}Cubit');
  //   if (status == 'true') {
  //     emit(Online());
  //   } else {
  //     emit(Offline());
  //   }

  //   return;
  // }
}
