import 'dart:convert';
import 'dart:developer';

// ignore: library_prefixes
import 'package:chat_app/Logic/Network/network_services.dart';
import 'package:chat_app/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  IO.Socket socket = IO.io(
      'http://localhost:5000',
      OptionBuilder().setTransports(['websocket']).setExtraHeaders(
        {
          // ignore: unnecessary_string_interpolations
          "id": "${NetworkServices.id}",
          // ignore: unnecessary_string_interpolations
          "key": "${NetworkServices.key}"
        },
      )
          // .disableAutoConnect()
          .build());

  initConnection() {
    socket.connect();
    socket.on('connection', (_) {
      log('connect ${_.toString()}');
      print('A message here ');
    });
    connectionCubit.connecting();
    log('Trying Connection');
    socket.onConnect((_) {
      log('connect');
      connectionCubit.reset();
    });
    socket.on('message', (data) {
      print('objectss: $data');
    });

    socket.on("isOnline", (data) {
      log(data.toString());
    });
  }

  // dynamic checkStatus(userId) {
  //   // checkOnlineStatus(userId) {
  //   final dynamic body = {"id": "$userId"};
  //   socket.emit('isOnline', jsonEncode(body));

  //   final status = socket.on('isOnline', (data) {
  //     OnlineStatusCubit(userId).checkOnlineStatus();
  //   });
  //   return status;
  // }

  sendMessage(message) {
    // print('send');
    socket.emit('message', jsonEncode(message));
  }
}
