import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Logic/Offline/offline_conversations.dart';
import 'package:chat_app/Logic/Offline/shared_preferences_service.dart';
import 'package:chat_app/Network/firebase_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Models/conversation.dart';
import 'package:chat_app/Models/user.dart';
import 'package:http/http.dart' as http;

import '../Constants/constants.dart';
// import '';

// import 'package:chat_app/Logic/Network/socket_service.dart';

class NetworkServices {
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

      socketService.initConnection();
      final user = UserModel.fromJson(data);

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
    String phone,
    String avatar,
  ) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    logger.e(fcmToken);
    logger.e('avatar: $avatar');

    final response = await http.post(
      headers: {'Content-Type': 'application/json'},
      Uri.parse(registerUrl),
      body: jsonEncode({
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "token": fcmToken,
        "avatar": avatar,
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      id = data['user']['_id'];

      key = data['key'];

      user = response.body;

      final userModel = UserModel.fromJson(data['user']);

      await saveTokens();

      socketService.initConnection();
      log('initialized connection');

      return userModel;
    } else if (response.statusCode == 400) {
      throw data['message'];
    } else {
      // print(data);
      throw data['message'];
    }
  }

  Future<UserModel> editPhone(String phone) async {
    await loadTokens();
    final response = await http.put(
      Uri.parse(editPhoneNumber),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Api-Key $key",
      },
      body: jsonEncode({
        "phone": phone,
      }),
    );

    log(response.body);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      user = response.body;

      final userModel = UserModel.fromJson(data['user']);
      await saveTokens();
      return userModel;
    } else {
      throw data['message'];
    }
  }

  Future<UserModel> editPhoto(File imageFile) async {
    await loadTokens();

    final avatar = await FirebaseStorageService.uploadImageToFirebase(
        imageFile, DateTime.now().toString());

    final response = await http.put(
      Uri.parse(editProfilePhoto),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Api-Key $key",
      },
      body: jsonEncode({
        "url": avatar,
      }),
    );

    log(response.body);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      user = response.body;

      final userModel = UserModel.fromJson(data['user']);
      await saveTokens();
      return userModel;
    } else {
      throw data['message'];
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
      // print(e.toString());
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

    logger.f(response.body);
    final data = jsonDecode(response.body);
    // log(response.body.toString());
    if (response.statusCode == 201) {
      final conversation = Conversation.fromJson(data['conversation']);
      return conversation;
    } else if (response.statusCode == 404) {
      throw data['message'];
    } else {
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
    ).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        // conversationsCubit.getLocalConversations();
        return http.Response(
            jsonEncode({
              'message': 'Connection timeout',
            }),
            408);
      },
    );

    logger.f(response.body);

    if (response.statusCode == 200) {
      Prefs.remove(OfflineService.keyConversations);

      final data = jsonDecode(response.body)['conversations'] as List<dynamic>;
      final conversations =
          data.map((json) => Conversation.fromJson(json)).toList();

      await OfflineService.saveConversations(conversations);

      return conversations;
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  Future updateSeenStatus(
      List<String> messageIndex, String conversationId) async {
    final response = await http.post(Uri.parse(seenMessage),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Api-Key ${NetworkServices.key}",
        },
        body: jsonEncode({
          "conversationId": conversationId,
          "messageIds": messageIndex,
        }));

    logger.f(messageIndex);

    if (response.statusCode == 200) {
      logger.e('Successfully updated, $messageIndex');
    } else {
      logger.e('Update failed');
    }
  }

  Future<bool> deleteUser() async {
    final response = await http.post(
      Uri.parse(deleteAccount),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Api-Key ${NetworkServices.key}'
      },
    );

    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode == 201) {
      await FirebaseMessaging.instance.deleteToken();
      await loadTokens();
      log('User deleted');

      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteConversation(String userId, String conversationId) async {
    await loadTokens();
    final res = await http.post(Uri.parse(deleteConvo),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Api-Key ${NetworkServices.key}'
        },
        body: jsonEncode({
          "conversationId": conversationId,
          "userId": userId,
        }));
    // final data = jsonDecode(res.body);

    logger.f(res.statusCode.toString());
    if (res.statusCode != 200) {
      return false;
      // throw data['message'];
    }
    return true;
  }
}
