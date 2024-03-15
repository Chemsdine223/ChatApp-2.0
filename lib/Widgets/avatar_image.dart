import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:chat_app/Constants/constants.dart';

// ignore: must_be_immutable
class AvatarImage extends StatefulWidget {
  final String image;
  int? radius;
  AvatarImage({
    Key? key,
    required this.image,
    this.radius,
  }) : super(key: key);

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  bool error = false;
  @override
  Widget build(BuildContext context) {
    log(widget.image);
    return CircleAvatar(
      radius: widget.radius != null ? widget.radius!.toDouble() : 20,
      // radius: widget.radius!.toDouble() ,
      onBackgroundImageError: (exception, stackTrace) {
        setState(() {
          error = true;
        });
      },
      backgroundImage: NetworkImage(widget.image),
      child: error == true || hasConnection == false
          ? const Icon(Icons.person)
          : Container(),
    );
  }
}
