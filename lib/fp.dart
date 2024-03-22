import 'package:kelas_king_fe/model/bg.dart';
import 'package:kelas_king_fe/model/button.dart';
import 'package:kelas_king_fe/model/txt.dart';
import 'package:kelas_king_fe/model/txtfield.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Fp extends StatelessWidget {
  String email;
  Fp({required this.email});
  final _formKey = GlobalKey<FormState>();

  TextEditingController _tokenController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //var urlProvider = Provider.of<UrlProvider>(context);
    //var currentUrl = urlProvider.url;

    //future

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
                    left: width / 15,
                    right: width / 15,
                    bottom: width / 20,
                    top: height > width ? width / 2 : width / 20),
                child: Bg(
                    child: Padding(
                  padding: EdgeInsets.all(width / 15),
                  child: Column(
                    children: [
                      TxtBg(txt: 'Reset Password'),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          '*cek token pada alamat email $email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TxtField(
                                  controller: _tokenController,
                                  hint: 'Token',
                                  icon: Icon(
                                    Icons.numbers,
                                    color: Colors.grey,
                                  ),
                                  validator: 'isi token!'),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: width / 20, top: 10),
                                child: TxtField(
                                    controller: _passwordController,
                                    hint: 'Password Baru',
                                    icon: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    validator: 'isi password baru!'),
                              ),
                              Button(
                                  txt: 'Reset',
                                  color: Color(0xff85CBCB),
                                  shadow: Color(0xffA8DEE0),
                                  op: () async {
                                    if (_formKey.currentState!.validate()) {}
                                  }),
                              Divider(
                                color: Colors.grey,
                              ),
                              Button(
                                  txt: 'Batal',
                                  color: Color(0xffFBC78D),
                                  shadow: Color(0xffF9E2AE),
                                  op: () {
                                    Navigator.pop(context);
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
