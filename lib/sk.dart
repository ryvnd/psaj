import 'package:flutter/material.dart';

class Sk extends StatelessWidget {
  const Sk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
