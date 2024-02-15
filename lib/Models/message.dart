import 'package:chat_app/Models/user.dart';

class Message {
  final String conversationId;
  final String content;
  final UserModel sender;
  final UserModel receiver;

  Message({
    required this.conversationId,
    required this.content,
    required this.sender,
    required this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      conversationId: json['room'],
      content: json['content'],
      sender: UserModel.fromJson(json['sender'] ?? json['user'] ?? {}),
      receiver: UserModel.fromJson(json['receiver'] ?? json['user'] ?? {}),
    );
  }
}
