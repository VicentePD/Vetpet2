import 'package:flutter/material.dart';

class AvatarPet extends StatelessWidget {

  final ImageProvider imgAvatar ;

    AvatarPet(this.imgAvatar, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CircleAvatar(
        radius: 25,
        backgroundImage: imgAvatar,
        backgroundColor: const Color(0xffFDCF09));
  }
}

