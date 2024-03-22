import 'dart:convert';

import 'package:kelas_king_fe/bnb.dart';
import 'package:kelas_king_fe/fp.dart';
import 'package:kelas_king_fe/model/bg.dart';
import 'package:kelas_king_fe/model/button.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/model/txt.dart';
import 'package:kelas_king_fe/model/txtfield.dart';
import 'package:kelas_king_fe/register.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future login() async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var response = await http.post(Uri.parse(currentUrl + 'api/login'),
            body: {
              "email": _emailController.text,
              "password": _passwordController.text
            });
        Map data = json.decode(response.body);
        String message = data['message'];
        if (message == 'Login berhasil') {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Bnb(datauser: data, idx: 0)));
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return Eror(txt: message);
              });
        }
      } catch (e) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return Eror(txt: e.toString());
            });
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'images/bgup.png',
                height: height / 4,
                width: width,
                fit: BoxFit.fill,
              ),
              Image.asset(
                'images/bgdown.png',
                height: height / 4,
                width: width,
                fit: BoxFit.fill,
              ),
            ],
          ),
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: width / 3, left: width / 3, top: height / 6),
                child: Image.asset('images/logo.png'),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: width / 15, vertical: 20),
                child: Bg(
                    child: Padding(
                  padding: EdgeInsets.all(width / 15),
                  child: Column(
                    children: [
                      TxtBg(txt: 'Login'),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: TxtField(
                                    controller: _emailController,
                                    hint: 'Email',
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                    validator: 'isi email!'),
                              ),
                              TxtFieldPw(controller: _passwordController),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        _emailController.text == ''
                                            ? showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Eror(
                                                      txt: 'isi email!');
                                                })
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Fp(
                                                          email:
                                                              _emailController
                                                                  .text,
                                                        )));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text('Lupa password?'),
                                      )),
                                ],
                              ),
                              Button(
                                  txt: 'Login',
                                  color: Color(0xff85CBCB),
                                  shadow: Color(0xffA8DEE0),
                                  op: () async {
                                    if (_formKey.currentState!.validate()) {
                                      login();
                                    }
                                  }),
                              Divider(
                                color: Colors.grey,
                              ),
                              Button(
                                  txt: 'Register',
                                  color: Color(0xffFBC78D),
                                  shadow: Color(0xffF9E2AE),
                                  op: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()));
                                  }),
                            ],
                          ))
                    ],
                  ),
                )),
              )
            ],
          )
        ],
      ),
    );
  }
}
