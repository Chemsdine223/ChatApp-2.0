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
      // print('A message here ');
    });
    print(socket.acks);
    connectionCubit.connecting();
    log('Trying Connection');
    socket.onConnect((_) {
      log('connect');
      connectionCubit.reset();
    });

    socket.on('message', (data) {
      // print('objectss: $data');
    });

    // final Map<String, String> typingStatusMap = {};
    // socket.on('stoppedTyping', (data) {
    //   final conversationId = data['conversationId'];
    //   typingStatusMap.remove(conversationId);
    //   typingStatusCubit.handleTypingStatus(typingStatusMap);
    //   // typingStatusMap[conversationId] = conversationId;
    //   // log(typingStatusMap.toString());
    //   // TypingStatusCubit();
    // });

    // 65cb5c283b31a287917ed3f5

    // socket.on('typing', (data) {
    //   final conversationId = data['conversationId'];
    //   typingStatusMap[conversationId] = conversationId;
    //   typingStatusCubit.handleTypingStatus(typingStatusMap);
    //   log(typingStatusMap.toString());
    //   // TypingStatusCubit();
    // });
    socket.on('onlineUsers', (data) {
      onlineStatusCubit.checkOnlineStatus(false, data['users']);
      // print('----------------------------');
      // print(data);
      // print('----------------------------');
    });

    // socket.on("isOnline", (data) {
    //   log(data.toString());
    //   log('Decode :::::::::');
    //   log(data['status'].toString());

    //   onlineStatusCubit.checkOnlineStatus(data['status']);

    //   // print(data['status'] == false);
    // });
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

  // checkStatus(String id) {
  //   socket.emit(
  //       'isOnline',
  //       jsonEncode({
  //         "id": id,
  //       }));
  // }

  sendTypingStatus(body) {
    socket.emit('typing', jsonEncode(body));
  }

  sendMessage(message) {
    // print('send');
    socket.emit('message', jsonEncode(message));
  }
}
