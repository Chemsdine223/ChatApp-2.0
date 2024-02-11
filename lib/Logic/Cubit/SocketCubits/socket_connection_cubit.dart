import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'socket_connection_state.dart';

class SocketConnectionCubit extends Cubit<SocketConnectionState> {
  SocketConnectionCubit() : super(SocketConnectionInitial());

  void connecting() {
    emit(Connecting());
  }

  void disconnected() {
    emit(Disconnected());
  }

  void reset() {
    emit(SocketConnectionInitial());
  }
}
