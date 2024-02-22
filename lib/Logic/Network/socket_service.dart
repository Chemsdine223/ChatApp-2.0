import 'dart:convert';

// ignore: library_prefixes
import 'package:chat_app/Logic/Network/network_services.dart';
import 'package:chat_app/Providers/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as manager;
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  Socket socket = manager.io(
      // 'http://localhost:5000',
      'http://172.20.10.5:5000',
      // 'http://192.168.100.30:5000',
      OptionBuilder().setTransports(['websocket']).build());

  initConnection() async {
    socket.dispose();
    provider = SocketProvider();

    socket.io.options!['extraHeaders'] = {
      // ignore: unnecessary_string_interpolations
      "id": "${NetworkServices.id}",
      // ignore: unnecessary_string_interpolations
      "key": "${NetworkServices.key}",
    };
    socket.connect();
  }

  sendTypingStatus(body) {
    socket.emit('typing', jsonEncode(body));
  }

  sendMessage(message) {
    // print('send');
    socket.emit('message', jsonEncode(message));
  }
}
