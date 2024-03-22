import 'package:flutter/material.dart';

class DataNull extends StatelessWidget {
  final txt;
  DataNull({
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Icon(
          Icons.search_off_rounded,
          color: Color(0xffFF6962),
          size: width / 3,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            txt,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
