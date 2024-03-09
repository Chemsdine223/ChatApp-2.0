import 'package:chat_app/Constants/constants.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatefulWidget {
  final String image;
  const AvatarImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  bool error = false;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: error == false ? NetworkImage(widget.image) : null,
      onBackgroundImageError: (exception, stackTrace) {
        setState(() {
          error = true;
        });
      },
      child: error == true || hasConnection == false
          ? const Icon(Icons.person)
          : null,
    );
  }
}
