import 'dart:convert';
import 'dart:developer';

// ignore: library_prefixes
import 'package:chat_app/Logic/Network/network_services.dart';
import 'package:chat_app/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../Models/message.dart';

class SocketService {
  Socket socket = IO.io(
      'http://localhost:5000',
      OptionBuilder().setTransports(['websocket'])
          // .disableAutoConnect()
          .build());

  initConnection() async {
    socket.dispose();
    // final prefs = await SharedPreferences.getInstance();
    // final key = prefs.get('key');
    // final id = prefs.get('id');
    socket.io.options!['extraHeaders'] = {
      // ignore: unnecessary_string_interpolations
      "id": "${NetworkServices.id}",
      // ignore: unnecessary_string_interpolations
      "key": "${NetworkServices.key}",
    };

    // stream

    log('options: ${socket.opts}');

    socket.connect();

    // StreamRepository().getStream();
    // stream.sink.addStream(socket.io.); // Reconnect the socket manually.

    // final y = ref.watch(providerOfSocket);

    socket.on('connection', (_) {
      log('connect ${_.toString()}');
      // print('A message here ');
    });

    // socket.onConnectError(
    //   (data) {
    //     log(data);
    //   },
    // );
    print(socket.acks);
    connectionCubit.connecting();
    log('Trying Connection');
    log(socket.io.options.toString());
    socket.onConnect((_) {
      log('connect');

      // stream.add('connect');x
      // log(stream.add);

      conversationsCubit.getConversations();
      connectionCubit.reset();
    });

    socket.onAny((event, data) {
      log(event.toString());
      log('This is the event: $event and this is the data: $data');
    });

    // socket.onConnectError((data) {
    //   socket.io.reconnect();
    // });

    // List<Message> messages = [];
    socket.on('message', (data) {
      final message = Message.fromJson(data['message']);
      // messages.add(message);
      // stream.add(messages);
      conversationsCubit.processReceivedMessage(message);
    });

    socket.on('onlineUsers', (data) {
      onlineStatusCubit.checkOnlineStatus(false, data['users']);
      // print('----------------------------');
      // print(data);
      // print('----------------------------');
    });
  }

  sendTypingStatus(body) {
    socket.emit('typing', jsonEncode(body));
  }

  sendMessage(message) {
    // print('send');
    socket.emit('message', jsonEncode(message));
  }
}
// class SocketService {
//   Socket socket = IO.io(
//       'http://localhost:5000',
//       OptionBuilder().setTransports(['websocket'])
//           // .setExtraHeaders(
//           //   {
//           //     // ignore: unnecessary_string_interpolations
//           //     "id": "222",
//           //     // ignore: unnecessary_string_interpolations
//           //     "key": "22y"
//           //   },
//           // )
//           .build());

//   late String s = '7';

//   void editString(String newStirng) {
//     // socket = newSocket;
//     // print(s);

//     socket.io.options!['extraHeaders'] = {'foo': 'bar'};
//     s = newStirng;
//     print('$s after modification');
//     print('${socket.opts} after modification');
//   }

//   void printerr() {
//     print(s);
//     print(socket.opts);
//     // print(socket.opts);
//   }
// }
// // class SocketService {
// //   IO.Socket _socket;

// //   // Constructor
// //   SocketService(IO.Socket socket) : _socket = socket;

// //   // Getter for socket
// //   IO.Socket get socket => _socket;

// //   // Setter for socket
// //   set socket(IO.Socket newSocket) {
// //     _socket = newSocket;
// //   }

 
// }
