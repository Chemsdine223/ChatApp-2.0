// import 'package:chat_app/Logic/Network/network_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:socket_io_client/socket_io_client.dart';

final supabase = Supabase.instance.client;

// dynamic extraHeaders = {
//   'id': "44",
//   'key': "44",
// };

String id = '';
String key = '';

String f = key + id;

int x = 0;



// class TestClass {
//   static String _id = '1'; // Private variable

//   static String get id => _id; // Getter method to retrieve the value

//   static set id(String value) {
//     _id = value;
//   }
// }

// class MyClass {
//   static String get s => NetworkServices.id; // Getter for s
// }

// // IO.S

// // final String phoneError = 'Enter a phone number';

// var s = TestClass.id;

// IO.Socket socket = IO.io(
//     'http://localhost:5000',
//     OptionBuilder().setTransports(['websocket']).setExtraHeaders(
//       {
//         // ignore: unnecessary_string_interpolations
//         "id": "${NetworkServices.id}",
//         // ignore: unnecessary_string_interpolations
//         "key": "${NetworkServices.key}"
//       },
//     )
//         // .disableAutoConnect()
//         .build());
