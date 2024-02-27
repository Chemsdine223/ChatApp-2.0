import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Models/conversation.dart';
import 'package:chat_app/Logic/Network/network_services.dart';

import '../../../Models/message.dart';

part 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  ConversationsCubit() : super(ConversationsInitial()) {
    getConversations();
  }
  Future<void> getConversations() async {
    print('getting conversations');
    emit(ConversationsLoading());
    try {
      final response = await NetworkServices().getConversations();
      emit(ConversationsLoaded(conversations: response));
    } catch (e) {
      emit(ConversationsError(errorMessage: e.toString()));
    }
  }

  createConversation(List<Conversation> conversations, String phone,
      BuildContext context) async {
    try {
      final conversation = await NetworkServices().newChat(phone);
      conversations.add(conversation);
      emit(ConversationsLoaded(conversations: conversations));
      // log('Hi');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      emit(ConversationsLoaded(conversations: conversations));
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

      emit(ConversationsLoaded(conversations: List.from(sstate.conversations)));
    }
  }
}
