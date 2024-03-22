import 'dart:convert';

import 'package:kelas_king_fe/model/button.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/model/show/absensi.dart';
import 'package:kelas_king_fe/model/txtfield.dart';
import 'package:kelas_king_fe/setting.dart';
import 'package:kelas_king_fe/student/absensi.dart';
import 'package:kelas_king_fe/student/course.dart';
import 'package:kelas_king_fe/student/tugas.dart';
import 'package:kelas_king_fe/teacher/absensi.dart';
import 'package:kelas_king_fe/teacher/course.dart';
import 'package:kelas_king_fe/teacher/tugas.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Bnb extends StatefulWidget {
  final Map datauser;
  final int idx;
  Bnb({
    required this.datauser,
    required this.idx,
  });

  @override
  State<Bnb> createState() => _BnbState();
}

class _BnbState extends State<Bnb> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _kodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  String? yesOrNO;

  List<String> items = ['Buat', 'Tidak'];

  bool value = false;

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.idx;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    final List<Widget> bodyPelajar = [
      Course(
        datauser: widget.datauser,
      ),
      Absensi(
        datauser: widget.datauser,
      ),
      Tugas(
        datauser: widget.datauser,
      ),
      Setting(
        datauser: widget.datauser,
      ),
    ];

    final List<Widget> bodyPengajar = [
      TCourse(
        datauser: widget.datauser,
      ),
      TAbsensi(
        datauser: widget.datauser,
      ),
      TTugas(
        datauser: widget.datauser,
      ),
      Setting(
        datauser: widget.datauser,
      ),
    ];

    //future
    Future addCourse() async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var response =
            await http.post(Uri.parse(currentUrl + 'api/add-course'), body: {
          "nama": _nameController.text,
          "instructor_id": widget.datauser['data']['id'].toString(),
          "absen": yesOrNO == 'Buat' ? 'yes' : 'no',
        });
        Map data = json.decode(response.body);
        String message = data['message'];
        if (message == 'Course berhasil dibuat') {
          Navigator.pop(context);
          yesOrNO == 'Buat'
              ? showDialog(
                  context: context,
                  builder: (context) {
                    return PopUpAbsensi(
                      datauser: widget.datauser,
                      id: data['data']['id'].toString(),
                    );
                  })
              : Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Bnb(datauser: widget.datauser, idx: 0)));
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

    Future joinCourse() async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var response =
            await http.post(Uri.parse(currentUrl + 'api/join-course'), body: {
          "course_id": _kodeController.text,
          "user_id": widget.datauser['data']['id'].toString(),
        });
        Map data = json.decode(response.body);
        String message = data['message'];
        if (message == 'Berhasil bergabung course') {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Bnb(datauser: widget.datauser, idx: 0)));
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

    void ontap(index) {
      setState(() {
        currentIndex = index;
      });
    }

    body() {
      if (widget.datauser['data']['role'] == 'Pelajar') {
        return bodyPelajar[currentIndex];
      } else {
        return bodyPengajar[currentIndex];
      }
    }

    bnb(width) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.book),
            onPressed: () => ontap(0),
            color: currentIndex == 0 ? Color(0xff85CBCB) : Color(0xffB3B3B3),
          ),
          IconButton(
            icon: Icon(Icons.check_circle),
            onPressed: () => ontap(1),
            color: currentIndex == 1 ? Color(0xff85CBCB) : Color(0xffB3B3B3),
          ),
          SizedBox(
            width: width / 10,
          ),
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () => ontap(2),
            color: currentIndex == 2 ? Color(0xff85CBCB) : Color(0xffB3B3B3),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => ontap(3),
            color: currentIndex == 3 ? Color(0xff85CBCB) : Color(0xffB3B3B3),
          ),
        ],
      );
    }

    addOrJoin() {
      if (widget.datauser['data']['role'] == 'Pelajar') {
        return showDialog(
            context: context,
            builder: (context) {
              return PopUp(
                title: "Gabung Course",
                form: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TxtField(
                              controller: _kodeController,
                              hint: 'Kode course',
                              icon: Icon(
                                Icons.key,
                                color: Colors.grey,
                              ),
                              validator: 'isi kode course!'),
                        ),
                        Button(
                            txt: 'Gabung',
                            color: Color(0xff85CBCB),
                            shadow: Color(0xffA8DEE0),
                            op: () async {
                              if (_formKey.currentState!.validate()) {
                                joinCourse();
                              }
                            }),
                      ],
                    )),
              );
            });
      } else {
        return showDialog(
            context: context,
            builder: (context) {
              return PopUp(
                title: "Buat Course",
                form: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: TxtField(
                              controller: _nameController,
                              hint: 'Nama course',
                              icon: Icon(
                                Icons.book,
                                color: Colors.grey,
                              ),
                              validator: 'isi nama course!'),
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: width / 30),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.grey,
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            hintText: 'Buat absensi',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'pilih absensi!';
                            }
                            return null;
                          },
                          value: yesOrNO,
                          items: items
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              yesOrNO = newValue as String?;
                              value = (yesOrNO != null);
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Button(
                            txt: 'Buat',
                            color: Color(0xff85CBCB),
                            shadow: Color(0xffA8DEE0),
                            op: () async {
                              if (_formKey.currentState!.validate()) {
                                addCourse();
                              }
                            }),
                      ],
                    )),
              );
            });
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff85CBCB),
          onPressed: () {
            addOrJoin();
          },
          child: Icon(Icons.add),
        ),
        body: body(),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xffFFF5EA),
          shape: CircularNotchedRectangle(),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: width / 50),
              child: bnb(width)),
        ));
  }
}
