import 'dart:convert';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Logic/Models/conversation.dart';
import 'package:chat_app/Logic/Models/user.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/Logic/Network/socket_service.dart';

// import 'package:chat_app/Logic/Network/socket_service.dart';

class NetworkServices {
  static const baseUrl = 'http://127.0.0.1:5000';
  final loginUrl = '$baseUrl/api/login';
  final registerUrl = '$baseUrl/api/register';
  final getConvos = '$baseUrl/api/getConvos';
  final getBlogs = '$baseUrl/api/getBlogs';
  final createConvo = '$baseUrl/api/createConversation';

  static String token = '';
  static String id = '';
  static String key = '';
  static String user = '';

  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "username": username,
          "password": password,
        },
      ),
    );

    final data = jsonDecode(response.body);

    // print(data);

    if (response.statusCode == 200) {
      token = data['token'];

      id = data['user']['_id'];

      await saveTokens();

      SocketService().initConnection();
      final user = UserModel.fromJson(data);
      // print();

      // connectAndListen(data['token'], data['user']['_id']);

      return user;
    } else if (response.statusCode == 400) {
      throw data['message'];
    } else {
      throw data['message'];
    }
  }

  Future<UserModel> register(
    String username,
    String firstname,
    String lastname,
    // String password,
    String phone,
  ) async {
    final response = await http.post(
      headers: {'Content-Type': 'application/json'},
      Uri.parse(registerUrl),
      body: jsonEncode({
        "username": username,
        // "password": password,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
      }),
    );
    final data = jsonDecode(response.body);

    // final SharedPreferences prefs = await SharedPreferences.getInstance();

//    print(response.body);

    if (response.statusCode == 200) {
      // print(data['token']);
      // final access = await prefs.setString('token', data['token']);
      // token = data['token'];
      id = data['user']['_id'];
      // print('Data: $data');
      // print('API KEY: ${data['key']}');

      key = data['key'];
      // key = data['key'];

      user = response.body;

      final userModel = UserModel.fromJson(data);
      // StreamSocket().
      // connectAndListen();

      await saveTokens();

      return userModel;
    } else if (response.statusCode == 400) {
      throw data['message'];
    } else {
      // print(data);
      throw 'message';
    }
  }

  static Future<void> saveTokens() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('access', token);
    await prefs.setString('key', key);
    await prefs.setString('id', id);
    await prefs.setString('user', user.toString());
  }

  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();

    id = prefs.getString('id').toString();
    key = prefs.getString('key').toString();
  }

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      print(e.toString());
    }
    return contacts;
  }

  Future<Conversation> newChat(String phone) async {
    // log(createConvo);
    await loadTokens();
    final response = await http.post(
      Uri.parse(createConvo),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Api-Key $key",
      },
      body: jsonEncode({
        "phone": phone,
      }),
    );
    final data = jsonDecode(response.body);
    // log(response.body.toString());
    if (response.statusCode == 201) {
      final conversation = Conversation.fromJson(data['conversation']);
      // log('-----------------------------');
      // log(conversation.toString());
      // log('-----------------------------');

      // conversationsCubit.createConversation(conversation);
      // if (context.mounted) {
      //   Navigator.pop(context);
      // }

      return conversation;
    } else if (response.statusCode == 404) {
      // if (context.mounted) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text(data['message'])));
      // }
      throw data['message'];
      // throw '';
    } else {
      // if (context.mounted) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text(data['message'])));
      //   Navigator.pop(context);
      // }
      throw data['message'];
    }
  }

  Future<List<Conversation>> getConversations() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final apiKey = sharedPreferences.getString('key');

    await loadTokens();
    // print('Key: $apiKey');
    final response = await http.get(
      Uri.parse(getConvos),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Api-Key $apiKey",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['conversations'] as List<dynamic>;

      // print("This is the conversation response ${response.body}");

      final conversations =
          data.map((json) => Conversation.fromJson(json)).toList();

      // print(conversations);

      return conversations;
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }
}
