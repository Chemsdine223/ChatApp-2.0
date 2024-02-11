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
    connectionCubit.reset();
    conversationsCubit.getConversations();
  });

  List<Message> messages = [];
  SocketService().socket.on('message', (data) {
    final message = Message.fromJson(data['message']);
    messages.add(message);
    stream.add(messages);
    conversationsCubit.processReceivedMessage(message);
  });
  print('Messages List $messages');

  SocketService().socket.onerror((_) {
    log("Error IS ${_.toString()}");
  });

  await for (final value in stream.stream) {
    log('stream value => $value');
    yield value;
  }
});
