import 'package:flutter/material.dart';

class TxtBg extends StatelessWidget {
  final String txt;
  TxtBg({
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          fontWeight: FontWeight.bold, letterSpacing: 4, fontSize: 20),
    );
  }
}
