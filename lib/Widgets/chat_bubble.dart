import 'package:flutter/material.dart';

import '../Logic/Models/message.dart';

class ChatBubble extends StatelessWidget {
  final bool incoming;
  final Message message;

  const ChatBubble({
    Key? key,
    required this.incoming,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.bottomLeft,
      // constraints: const BoxConstraints(minWidth: 10, maxWidth: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      width: message.content.length <= 7 ? 70 : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            incoming == true ? Colors.blue.shade700 : Colors.greenAccent[400],
      ),
      child: Center(
        child: Text(
          message.content,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
