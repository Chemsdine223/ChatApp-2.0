import 'package:chat_app/Models/user.dart';

class Message {
  final String conversationId;
  final String content;
  bool isSeen;
  final UserModel sender;
  final UserModel receiver;

  Message({
    required this.conversationId,
    required this.content,
    required this.isSeen,
    required this.sender,
    required this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      conversationId: json['room'],
      isSeen: json['isSeen'],
      content: json['content'],
      sender: UserModel.fromJson(json['sender'] ?? json['user'] ?? {}),
      receiver: UserModel.fromJson(json['receiver'] ?? json['user'] ?? {}),
    );
  }

  Message copyWith({
    String? conversationId,
    String? content,
    bool? isSeen,
    UserModel? sender,
    UserModel? receiver,
  }) {
    return Message(
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      isSeen: isSeen ?? this.isSeen,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
    );
  }
}
