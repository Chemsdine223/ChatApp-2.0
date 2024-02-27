import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/Models/conversation.dart';
import 'package:chat_app/Models/user.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Constants/constants.dart';
// import '';

// import 'package:chat_app/Logic/Network/socket_service.dart';

class NetworkServices {
  // static const baseUrl = 'http://127.0.0.1:5000';
  static const baseUrl = 'http://172.20.10.5:5000';
  // static const baseUrl = 'http://192.168.100.30:5000';
  // static const baseUrl = 'http://192.168.0.112:5000';
  final loginUrl = '$baseUrl/api/login';
  final registerUrl = '$baseUrl/api/register';
  final getConvos = '$baseUrl/api/getConvos';
  final getBlogs = '$baseUrl/api/getBlogs';
  final createConvo = '$baseUrl/api/createConversation';
  final deleteAccount = '$baseUrl/api/deleteAccount';
  final editPhoneNumber = '$baseUrl/api/editPhone';

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
    // String avatar,
  ) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final response = await http.post(
      headers: {'Content-Type': 'application/json'},
      Uri.parse(registerUrl),
      body: jsonEncode({
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "token": fcmToken,
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
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['conversations'] as List<dynamic>;
      final conversations =
          data.map((json) => Conversation.fromJson(json)).toList();

      // logger.f(conversations);
      // response.body;

      return conversations;
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  Future<String> editAvatar(XFile? avatar, String url) async {
    final File avatarFile = File(avatar!.path);

    // print(url);

    try {
      final path = await supabase.storage.from('avatars').update(
            'avatars/$url',
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      log(path);

      // final imageUrlResponse = await supabase.storage
      //     .from('avatars')
      //     .createSignedUrl('avatars/${avatar.name}', 60 * 60 * 24 * 365 * 10);
      // print('Successfully uploaded');

      // print(imageUrlResponse);
      return 'imageUrlResponse';
      // await supabase.storage.from('avatars').remove([
      //   'image_picker_C934624F-C857-4815-84F5-FB711AF33BC3-47843-0000161425348E84.jpg'
      // ]
      //     // avatarFile,
      //     // fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      //     );

      // final imageUrlResponse = await supabase.storage
      //     .from('avatars')
      //     .createSignedUrl('avatars/${avatar.name}', 60 * 60 * 24 * 365 * 10);

      // print(imageUrlResponse);
      // print('Successfully deleted');
      // return 'imageUrlResponse';
    } on StorageException catch (e) {
      log(e.toString());
      throw e.statusCode == '409' ? 'Error updating' : e.message;
    }
  }

  Future<String> uploadAvatar(XFile? avatar) async {
    final File avatarFile = File(avatar!.path);

    try {
      await supabase.storage.from('avatars').upload(
            'avatars/${avatar.name}',
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrlResponse = await supabase.storage
          .from('avatars')
          .createSignedUrl('avatars/${avatar.name}', 60 * 60 * 24 * 365 * 10);
      log('Successfully uploaded');

      logger.d(imageUrlResponse);
      return imageUrlResponse;
    } on StorageException catch (e) {
      throw e.statusCode == '409'
          ? 'You already uploaded this image'
          : e.message;
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
}
