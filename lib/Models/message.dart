import 'dart:convert';

import 'package:chat_app/Models/user.dart';

class Message {
  final String id;
  final String conversationId;
  final String content;
  final bool isSeen;
  final UserModel sender;
  final UserModel receiver;

  Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isSeen,
    required this.sender,
    required this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // logger.f(json);
    return Message(
      id: json['_id'],
      conversationId: json['room'],
      isSeen: json['isSeen'],
      content: json['content'],
      sender: UserModel.fromJson(json['sender'] ?? json['user'] ?? {}),
      receiver: UserModel.fromJson(json['receiver'] ?? json['user'] ?? {}),
    );
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? content,
    bool? isSeen,
    UserModel? sender,
    UserModel? receiver,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      isSeen: isSeen ?? this.isSeen,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_id': id});
    result.addAll({'room': conversationId});
    result.addAll({'content': content});
    result.addAll({'isSeen': isSeen});
    result.addAll({'sender': sender.toMap()});
    result.addAll({'receiver': receiver.toMap()});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] ?? '',
      conversationId: map['room'] ?? '',
      content: map['content'] ?? '',
      isSeen: map['isSeen'] ?? false,
      sender: UserModel.fromMap(map['sender']),
      receiver: UserModel.fromMap(map['receiver']),
    );
  }

  String toJson() => json.encode(toMap());
}
