import 'package:kelas_king_fe/model/button.dart';
import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/model/txtfield.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  final Map datauser;
  Setting({required this.datauser});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    String nomor = '+6282314355261';
    String pesan = 'Halo min!';
    final Uri url = Uri.parse('https://wa.me/$nomor?text=$pesan');
    Future whatsapp() async {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: Text(
            'Pengaturan',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: width / 3,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: width / 8,
                          child: widget.datauser['data']['role'] == 'Pelajar'
                              ? Icon(
                                  Icons.people,
                                  size: width / 7,
                                )
                              : Icon(
                                  Icons.school,
                                  size: width / 7,
                                ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withOpacity(0.1)),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                widget.datauser['data']['role'],
                                textAlign: TextAlign.center,
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hallo!'),
                          Text(
                            widget.datauser['data']['nama'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Popp(
                                    datauser: widget.datauser,
                                  );
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff85CBCB),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Edit Profil',
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              whatsapp();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff85CBCB),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Hubungi admin',
                          )
                        ],
                      )),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return LogOut();
                              });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Logout',
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class Popp extends StatefulWidget {
  final Map datauser;
  Popp({required this.datauser});

  @override
  State<Popp> createState() => _PoppState();
}

class _PoppState extends State<Popp> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  TextEditingController _namaController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _pwController = TextEditingController();
  TextEditingController _pwnwController = TextEditingController();

  bool _obscure = true;
  bool _1 = false;
  bool _2 = false;
  bool _3 = false;
  @override
  Widget build(BuildContext context) {
    _namaController.text = widget.datauser['data']['nama'];
    _emailController.text = widget.datauser['data']['email'];
    var width = MediaQuery.of(context).size.width;
    edit() {
      if (_1) {
        return Form(
          key: _formKey1,
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              TxtField(
                  controller: _namaController,
                  hint: 'Nama Baru',
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  validator: 'isi nama!'),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: TextFormField(
                  obscureText: _obscure,
                  controller: _pwController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: width / 30),
                        child: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: width / 50),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            child: _obscure
                                ? Icon(Icons.visibility_off, color: Colors.grey)
                                : Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  )),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      hintText: 'Password',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'isi password!';
                    }
                    return null;
                  },
                ),
              ),
              Button(
                  txt: 'Edit',
                  color: Color(0xff85CBCB),
                  shadow: Color(0xffA8DEE0),
                  op: () async {
                    if (_formKey1.currentState!.validate()) {}
                  }),
            ],
          ),
        );
      } else if (_2) {
        return Form(
          key: _formKey2,
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              TxtField(
                  controller: _emailController,
                  hint: 'Email Baru',
                  icon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  validator: 'isi email!'),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: TextFormField(
                  obscureText: _obscure,
                  controller: _pwController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: width / 30),
                        child: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: width / 50),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            child: _obscure
                                ? Icon(Icons.visibility_off, color: Colors.grey)
                                : Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  )),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      hintText: 'Password',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'isi password!';
                    }
                    return null;
                  },
                ),
              ),
              Button(
                  txt: 'Edit',
                  color: Color(0xff85CBCB),
                  shadow: Color(0xffA8DEE0),
                  op: () async {
                    if (_formKey2.currentState!.validate()) {}
                  }),
            ],
          ),
        );
      } else if (_3) {
        return Form(
          key: _formKey3,
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              TextFormField(
                obscureText: _obscure,
                controller: _pwController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(right: width / 30),
                      child: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: width / 50),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                          child: _obscure
                              ? Icon(Icons.visibility_off, color: Colors.grey)
                              : Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                )),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    hintText: 'Password',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'isi password!';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: TextFormField(
                  obscureText: _obscure,
                  controller: _pwnwController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: width / 30),
                        child: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: width / 50),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            child: _obscure
                                ? Icon(Icons.visibility_off, color: Colors.grey)
                                : Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  )),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      hintText: 'Password baru',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'isi password baru!';
                    }
                    return null;
                  },
                ),
              ),
              Button(
                  txt: 'Edit',
                  color: Color(0xff85CBCB),
                  shadow: Color(0xffA8DEE0),
                  op: () async {
                    if (_formKey3.currentState!.validate()) {}
                  }),
            ],
          ),
        );
      } else {
        return DataNull(txt: 'Pilih Edit!');
      }
    }

    return PopUp(
        title: 'Edit Profil',
        form: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: Container(
                width: width,
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _1 = true;
                          _2 = false;
                          _3 = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _1 ? Color(0xffFBC78D) : Color(0xffF9E2AE),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Edit Nama',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _2 = true;
                          _1 = false;
                          _3 = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _2 ? Color(0xffFBC78D) : Color(0xffF9E2AE),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Edit Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _3 = true;
                          _1 = false;
                          _2 = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _3 ? Color(0xffFBC78D) : Color(0xffF9E2AE),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Edit Password',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            edit()
          ],
        ));
  }
}
