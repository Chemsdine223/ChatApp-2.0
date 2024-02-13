part of 'online_status_cubit.dart';

sealed class OnlineStatusState extends Equatable {
  const OnlineStatusState();

  @override
  List<Object> get props => [];
}

final class OnlineStatusInitial extends OnlineStatusState {}

final class OnlineStatus extends OnlineStatusState {
  final bool status;
  final List<dynamic> onlineUsers;

  const OnlineStatus(this.status, this.onlineUsers);

  @override
  List<Object> get props => [status, onlineUsers];
}

 