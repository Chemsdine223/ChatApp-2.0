part of 'conversations_cubit.dart';

@immutable
sealed class ConversationsState extends Equatable {
  const ConversationsState();

  @override
  List<Object> get props => [];
}

final class ConversationsInitial extends ConversationsState {}

final class ConversationsLoaded extends ConversationsState {
  final List<Conversation> conversations;

  const ConversationsLoaded({required this.conversations});

  @override
  List<Object> get props => [conversations];
}

final class ConversationsLoading extends ConversationsState {}

final class DeletingConversation extends ConversationsState{}
final class DeletingConversationError extends ConversationsState{}

final class NewMessage extends ConversationsState {}

final class ConversationsError extends ConversationsState {
  final String errorMessage;

  const ConversationsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
