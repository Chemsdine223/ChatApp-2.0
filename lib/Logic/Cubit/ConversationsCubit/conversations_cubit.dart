import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/Logic/Offline/offline_conversations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Models/conversation.dart';
import 'package:chat_app/Logic/Network/network_services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../Constants/constants.dart';
import '../../../Models/message.dart';

part 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  ConversationsCubit() : super(ConversationsInitial()) {
    InternetConnectionChecker().onStatusChange.listen(
      (status) {
        switch (status) {
          // case InternetConnectionStatus.
          case InternetConnectionStatus.connected:
            logger.f('Data connection is available.');
            connectionCubit.reset();
            getConversations();
            break;
          case InternetConnectionStatus.disconnected:
            connectionCubit.disconnected();
            getLocalConversations();
            logger.e('You are disconnected from the internet.');
            break;
        }
      },
    );
  }

  Future<void> getConversations() async {
    print('getting conversations');
    emit(ConversationsLoading());
    try {
      final response = await NetworkServices().getConversations();
      emit(ConversationsLoaded(
        conversations: response,
      ));
    } catch (e) {
      logger.e(e);
      emit(ConversationsError(errorMessage: e.toString()));
    }
  }

  seenMessage(int messageIndex, bool isSeen, String conversationId) async {
    if (state is ConversationsLoaded) {
      final sstate = state as ConversationsLoaded;

      final existingIndex =
          sstate.conversations.indexWhere((c) => c.id == conversationId);

      if (existingIndex != -1) {
        // logger.f(
        //     'Before updating isSeen: ${sstate.conversations[existingIndex].messages[messageIndex].isSeen}');

        // Create a copy of the conversation and update the specific message
        final updatedConversation =
            sstate.conversations[existingIndex].copyWith(
          messages: List.from(sstate.conversations[existingIndex].messages)
            ..[messageIndex] = sstate
                .conversations[existingIndex].messages[messageIndex]
                .copyWith(isSeen: isSeen),
        );

        // Create a copy of the conversations list and update the specific conversation
        final List<Conversation> updatedConversations =
            List.from(sstate.conversations)
              ..[existingIndex] = updatedConversation;

        // logger.f(
        //     'After updating isSeen: ${updatedConversations[existingIndex].messages[messageIndex].isSeen}');

        // Emit the updated state
        emit(ConversationsLoaded(conversations: updatedConversations));
      }
    }

    logger.f('emitted');
  }

  deleteConversation(
      String conversationId, String userId, BuildContext context) async {
    if (state is ConversationsLoaded) {
      final sstate = state as ConversationsLoaded;
      final res =
          await NetworkServices().deleteConversation(userId, conversationId);

      if (res == true) {
        final existingIndex =
            sstate.conversations.indexWhere((c) => c.id == conversationId);

        if (existingIndex != -1) {
          final updatedConversations =
              List<Conversation>.from(sstate.conversations);
          updatedConversations.removeAt(existingIndex);
          emit(ConversationsLoaded(
            conversations: updatedConversations,
          ));
        }
      } else {
        emit(ConversationsLoaded(conversations: sstate.conversations));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Could't delete conversation")));
        }
      }
    }
  }

  createConversation(List<Conversation> conversations, String phone,
      BuildContext context) async {
    try {
      final conversation = await NetworkServices().newChat(phone);
      conversations.add(conversation);
      emit(ConversationsLoaded(
        conversations: conversations,
      ));
      // log('Hi');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      emit(ConversationsLoaded(
        conversations: conversations,
      ));
    }
  }

  resetConvos() {
    emit(ConversationsInitial());
  }

  void processReceivedMessage(Message message) {
    if (state is ConversationsLoaded) {
      final sstate = state as ConversationsLoaded;

      final conversationId = message.conversationId;
      final existingIndex =
          sstate.conversations.indexWhere((c) => c.id == conversationId);

      if (existingIndex != -1) {
        sstate.conversations[existingIndex].messages.add(message);
      } else {
        sstate.conversations.add(Conversation(
          id: conversationId,
          messages: [message],
          users: [message.sender, message.receiver],
        ));
      }

      emit(ConversationsLoaded(
        conversations: List.from(
          sstate.conversations,
        ),
      ));
    }
  }

  Future getLocalConversations() async {
    try {
      final conversations = await OfflineService().getConversations();
      logger.f('conversations: $conversations cubit');
      emit(ConversationsLoaded(conversations: conversations));
    } catch (e) {
      emit(ConversationsError(errorMessage: 'Storage error: $e'));
    }
  }
}
