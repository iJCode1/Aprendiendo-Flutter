import 'dart:io';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PastelIcon extends StatelessWidget {
  final radius;
  // final img;
  final String img2;

  const PastelIcon({
    Key? key,
    required this.img2,
    this.radius = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: new Offset(0.0, 0.0),
              blurRadius: 2.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.file(new File('$img2')))
    );
  }
}
