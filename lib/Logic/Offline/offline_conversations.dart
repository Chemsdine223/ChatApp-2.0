import 'dart:convert';

import 'package:chat_app/Constants/constants.dart';
import 'package:chat_app/Logic/Offline/shared_preferences_service.dart';

import '../../Models/conversation.dart';

class OfflineService {
  static const String keyConversations = 'conversations';

  static Future<void> saveConversations(
      List<Conversation> conversations) async {
    final conversationsList = conversations.map((e) => e.toMap()).toList();
    final conversationsString = jsonEncode(conversationsList);

    Prefs.setString(keyConversations, conversationsString);
  }

  Future<List<Conversation>> getConversations() async {
    final conversationsString = Prefs.getString(keyConversations);

    if (conversationsString != 'null') {
      final List<dynamic> conversationsList = jsonDecode(conversationsString);

      // Assuming you have a fromMap method in your Conversation class
      List<Conversation> conversations =
          conversationsList.map((map) => Conversation.fromMap(map)).toList();

      logger.f('Local conversations: $conversations');

      return conversations;
    } else {
      return [];
    }
  }
}
