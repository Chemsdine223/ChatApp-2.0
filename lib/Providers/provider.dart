import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/Logic/Network/socket_service.dart';
import 'package:chat_app/main.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../Logic/Models/message.dart';

final providerOfSocket = StreamProvider((ref) async* {
  StreamController stream = StreamController();

  SocketService().socket.onerror((err) => log(err.toString()));
  SocketService().socket.onDisconnect((_) => connectionCubit.disconnected());
  SocketService().socket.onReconnect((data) => connectionCubit.connecting());
  SocketService().socket.on('connected', (_) {
    log(_.toString());
    connectionCubit.reset();
    conversationsCubit.getConversations();
  });

  // SocketService().socket.on('onlineUsers', (data) {
  //   onlineStatusCubit.checkOnlineStatus(false, data['users']);
  //   log('$data The man dem');
  // });

  // final Map<String, String> typingStatusMap = {};
  SocketService().socket.on('typing', (data) {
    final conversationId = data['conversationId'];
    // typingStatusMap[conversationId] = conversationId;
    typingStatusCubit.handleTypingStatus(conversationId, true);
    // log(typingStatusMap.toString());
    // TypingStatusCubit();
  });

  SocketService().socket.on('stoppedTyping', (data) {
    final conversationId = data['conversationId'];
    // typingStatusMap.remove(conversationId);
    typingStatusCubit.handleTypingStatus(conversationId, false);
    // typingStatusMap[conversationId] = conversationId;
    // log(typingStatusMap.toString());
    // TypingStatusCubit();
  });

  List<Message> messages = [];
  SocketService().socket.on('message', (data) {
    final message = Message.fromJson(data['message']);
    messages.add(message);
    stream.add(messages);
    conversationsCubit.processReceivedMessage(message);
  });

  SocketService().socket.on('onlineUsers', (data) {
    log('isOnline $data');
    onlineStatusCubit.checkOnlineStatus(false, data['users']);
  });

  // SocketService().socket.on('onlineUsers', (data) {
  //   log('isOnline $data');
  //   onlineStatusCubit.checkOnlineStatus(false, data['users']);
  // });

  print('Messages List $messages');

  SocketService().socket.onerror((_) {
    log("Error IS ${_.toString()}");
  });

  await for (final value in stream.stream) {
    log('stream value => $value');
    yield value;
  }
});
