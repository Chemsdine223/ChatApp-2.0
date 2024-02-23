import 'dart:async';
import 'dart:developer';

import 'package:chat_app/Constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../Models/message.dart';

late SocketProvider provider;

class SocketProvider {
  final providerOfSocket = StreamProvider((ref) async* {
    StreamController stream = StreamController();

    socketService.socket.onerror((err) => log(err.toString()));
    socketService.socket.onDisconnect((_) {
      connectionCubit.disconnected();
      logger.f('Bye ${ref.state}');
    });

    socketService.socket.onConnect((data) {
      logger.e('Connected from provider');
      conversationsCubit.getConversations();
      connectionCubit.reset();
    });
    socketService.socket.onReconnect((data) => connectionCubit.connecting());
    socketService.socket.on('typing', (data) {
      final conversationId = data['conversationId'];
      typingStatusCubit.handleTypingStatus(conversationId, true);
    });

    socketService.socket.on('stoppedTyping', (data) {
      final conversationId = data['conversationId'];
      typingStatusCubit.handleTypingStatus(conversationId, false);
    });

    List<Message> messages = [];
    socketService.socket.on('message', (data) {
      final message = Message.fromJson(data['message']);
      messages.add(message);
      stream.add(messages);
      conversationsCubit.processReceivedMessage(message);
    });

    socketService.socket.on('onlineUsers', (data) {
      log('isOnline $data');
      onlineStatusCubit.checkOnlineStatus(false, data['users']);
    });
    socketService.socket.onerror((_) {
      log("Error IS ${_.toString()}");
    });

    await for (final value in stream.stream) {
      log('stream value => $value');
      yield value;
    }
  });
}
