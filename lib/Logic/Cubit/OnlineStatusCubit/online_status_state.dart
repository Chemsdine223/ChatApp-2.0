part of 'online_status_cubit.dart';

sealed class OnlineStatusState extends Equatable {
  const OnlineStatusState();

  @override
  List<Object> get props => [];
}

final class OnlineStatusInitial extends OnlineStatusState {}

final class Online extends OnlineStatusState {
  @override
  List<Object> get props => [];
}

final class Offline extends OnlineStatusState {
  @override
  List<Object> get props => [];
}
