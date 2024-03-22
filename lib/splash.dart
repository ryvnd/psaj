import 'package:kelas_king_fe/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'images/bgup.png',
            height: height / 4,
            width: width,
            fit: BoxFit.fill,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(50),
            child: Image.asset('images/logo.png'),
          )),
          Image.asset(
            'images/bgdown.png',
            height: height / 4,
            width: width,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
