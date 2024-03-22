import 'dart:convert';

import 'package:kelas_king_fe/bnb.dart';
import 'package:kelas_king_fe/model/button.dart';
import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/other.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/teacher/tugas_detail.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TMateriDetail extends StatefulWidget {
  final Map datamateri;
  final Map datauser;
  TMateriDetail({
    required this.datamateri,
    required this.datauser,
  });

  @override
  State<TMateriDetail> createState() => _TMateriDetailState();
}

class _TMateriDetailState extends State<TMateriDetail> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;
    print(widget.datamateri['id']);
    print(widget.datauser['data']['role']);

    //future
    Future getTugasPengajar() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/get-tugas/' +
              widget.datamateri['id'].toString()),
        );
        return json.decode(response.body);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return Eror(txt: e.toString());
            });
      }
    }

    Future launchurl() async {
      await launchUrl(Uri.parse(widget.datamateri['tautan']),
          mode: LaunchMode.externalApplication);
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Text(
            'Materi',
            style: TextStyle(color: Colors.black),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff85CBCB),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Builder(builder: (context) {
                    DateTime _selectedDate = DateTime.now();
                    int? _daysToAdd;

                    DateTime addDays(DateTime date, int days) {
                      return date.add(Duration(days: days));
                    }

                    final _formKey = GlobalKey<FormState>();
                    TextEditingController _tugasController =
                        TextEditingController();
                    TextEditingController _dateController =
                        TextEditingController();
                    Future addTugas() async {
                      try {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Wait();
                            });
                        var response = await http.post(
                            Uri.parse(currentUrl + 'api/add-tugas'),
                            body: {
                              "materi_id": widget.datamateri['id'].toString(),
                              "tugas": _tugasController.text,
                              "deadline": _selectedDate.toString(),
                            });
                        Map data = json.decode(response.body);
                        String message = data['message'];
                        if (message == 'Berhasil menambahkan tugas') {
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

                    return PopUp(
                        title: "Tambah Tugas",
                        form: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: TextFormField(
                                  maxLines: 3,
                                  controller: _tugasController,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      prefixIcon: Padding(
                                          padding: EdgeInsets.only(
                                              right: width / 30, bottom: 38),
                                          child: Icon(Icons.assignment,
                                              color: Colors.grey)),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 0,
                                        minHeight: 0,
                                      ),
                                      hintText: "Tugas",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "isi tugas!";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _dateController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                        padding:
                                            EdgeInsets.only(right: width / 30),
                                        child: Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey,
                                        )),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 0,
                                      minHeight: 0,
                                    ),
                                    hintText: 'Durasi (Hari)',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'isi durasi!';
                                  }
                                  return null;
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: Button(
                                    txt: 'Buat',
                                    color: Color(0xff85CBCB),
                                    shadow: Color(0xffA8DEE0),
                                    op: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _daysToAdd =
                                            int.tryParse(_dateController.text);
                                        if (_daysToAdd != null) {
                                          setState(() {
                                            _selectedDate = addDays(
                                                DateTime.now(), _daysToAdd!);
                                          });
                                        }
                                        addTugas();
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ));
                  });
                });
          },
          child: Icon(Icons.assignment),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                  height: width / 2,
                  width: width,
                  color: Color(0xff85CBCB).withOpacity(0.2),
                  child: widget.datamateri['foto'] != 'no'
                      ? Image.network(
                          currentUrl + 'images/' + widget.datamateri['foto'])
                      : Image.asset('images/logo.png')),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 10, left: 10),
              child: Judul(txt: 'Judul materi'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.datamateri['judul'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8, right: 10, left: 10, top: 10),
              child: Judul(txt: 'Materi'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.datamateri['tautan'] == 'no'
                      ? Container()
                      : Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        shadowColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        content: WillPopScope(
                                          onWillPop: () async {
                                            return false;
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        children: [
                                                          Text('Pergi ke'),
                                                          Text(
                                                            widget.datamateri[
                                                                'tautan'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      width / 4,
                                                                  height:
                                                                      width /
                                                                          10,
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Batal',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  launchurl();
                                                                },
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      width / 4,
                                                                  height:
                                                                      width /
                                                                          10,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      color: Color(
                                                                          0xff85CBCB)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Pergi',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Text(
                                widget.datamateri['tautan'],
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                  Text(
                    widget.datamateri['deskripsi'],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8, right: 10, left: 10, top: 10),
              child: Judul(txt: 'Tugas'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 20),
              child: FutureBuilder(
                  future: getTugasPengajar(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data['message'] ==
                              "Berhasil mendapatkan data"
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data['data'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TTugasDetail(
                                                      idx: (index + 1)
                                                          .toString(),
                                                      datatugas:
                                                          snapshot.data['data']
                                                              [index])));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFF5EA),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 1,
                                              offset: Offset(0, 2))
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tugas' +
                                                  ' ' +
                                                  (index + 1).toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data['data'][index]
                                                  ['tugas'],
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : DataNull(txt: snapshot.data['message']);
                    } else {
                      return Column(
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xff85CBCB),
                          )
                        ],
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
