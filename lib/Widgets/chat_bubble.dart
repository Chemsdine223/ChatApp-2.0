import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';

import '../Models/message.dart';

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
    return BubbleSpecialThree(
      textStyle:
          Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
      text: message.content,
      color: incoming ? Colors.green : Colors.blue,
      tail: false,
      isSender: incoming == true ? false : true,
      // seen: true,
    );
  }
}
