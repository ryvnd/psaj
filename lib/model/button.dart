import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String txt;
  final Color color;
  final Color shadow;
  final Function op;
  Button({
    required this.txt,
    required this.color,
    required this.shadow,
    required this.op,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width / 20),
          color: color,
          boxShadow: [
            BoxShadow(
                color: shadow.withOpacity(0.8),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 1))
          ]),
      child: GestureDetector(
        onTap: () {
          op();
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            txt,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
