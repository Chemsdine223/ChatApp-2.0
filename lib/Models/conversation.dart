import 'package:chat_app/Models/user.dart';

import 'message.dart';

class Conversation {
  final String id;
  final List<Message> messages;
  final List<UserModel> users;
  // final int v;

  Conversation({
    required this.id,
    required this.messages,
    required this.users,
    // required this.v,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    List<Message> messages = List.from(json['messages'])
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();

    List<UserModel> users = List.from(json['users'])
        .map((userJson) => UserModel.fromJson(userJson))
        .toList();

    return Conversation(
      id: json['_id'],
      messages: messages,
      users: users,
      // v: json['__v'],
    );
  }

  // Conversation copyWith({
  //   String? id,
  //   List<Message>? messages,
  //   List<String>? users,
  //   int? v,
  // }) {
  //   return Conversation(
  //     id: id ?? this.id,
  //     messages: messages ?? this.messages,
  //     // users: users ?? this.users,
  //     v: v ?? this.v,
  //   );
  // }

  Conversation copyWith({
    String? id,
    List<Message>? messages,
    List<UserModel>? users,
  }) {
    return Conversation(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      users: users ?? this.users,
    );
  }
}
