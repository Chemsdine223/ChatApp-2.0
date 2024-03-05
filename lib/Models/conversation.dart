import 'dart:convert';

import 'package:chat_app/Models/user.dart';

import 'message.dart';

class Conversation {
  final String id;
  final List<Message> messages;
  final List<UserModel> users;

  Conversation({
    required this.id,
    required this.messages,
    required this.users,
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'messages': messages.map((message) => message.toJson()).toList(),
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
  // String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'Conversation(id: $id, messages: $messages, users: $users)';

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'messages': messages.map((x) => x.toMap()).toList()});
    result.addAll({'users': users.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] ?? '',
      messages:
          List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
      users:
          List<UserModel>.from(map['users']?.map((x) => UserModel.fromMap(x))),
    );
  }

  // String toJson() => json.encode(toMap());

  factory Conversation.weirdfromJson(String source) =>
      Conversation.fromMap(json.decode(source));
}
