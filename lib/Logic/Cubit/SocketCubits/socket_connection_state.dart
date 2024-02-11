part of 'socket_connection_cubit.dart';

sealed class SocketConnectionState extends Equatable {
  const SocketConnectionState();

  @override
  List<Object> get props => [];
}

final class SocketConnectionInitial extends SocketConnectionState {}
final class Connecting extends SocketConnectionState {}
final class Disconnected extends SocketConnectionState {}
