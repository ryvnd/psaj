import 'dart:convert';

import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/other.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TTugas extends StatefulWidget {
  final Map datauser;
  TTugas({required this.datauser});

  @override
  State<TTugas> createState() => _TugasState();
}

class _TugasState extends State<TTugas> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nilai = TextEditingController();
  String namacourse = '';
  String id = '';
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future getCourseByTeacher() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/course/pengajar/' +
              widget.datauser['data']['id'].toString()),
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

    Future getPengumpulan() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/get-tugas-bycourse-pengajar/$namacourse' +
              '/' +
              widget.datauser['data']['id'].toString()),
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

    Future setnilai() async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var response = await http.put(
            Uri.parse(currentUrl + 'api/add-nilai/$id'),
            body: {'nilai': _nilai.text});
        Map data = json.decode(response.body);
        if (data['message'] == 'Nilai berhasil') {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return Eror(txt: data['message']);
              });
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return Eror(txt: e.toString());
            });
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          'Tugas',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return LogOut();
                  });
            },
            child: CircleAvatar(
              child: widget.datauser['data']['role'] == 'Pelajar'
                  ? Icon(Icons.people)
                  : Icon(Icons.school),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder(
              future: getCourseByTeacher(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data['message'] ==
                          "Course berhasil didapatkan"
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, left: 2),
                              child: Container(
                                width: width,
                                height: width / 10,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data['data'].length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              namacourse = snapshot.data['data']
                                                  [index]['nama'];
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: namacourse ==
                                                        snapshot.data['data']
                                                            [index]['nama']
                                                    ? Color(0xffFBC78D)
                                                    : Color(0xffF9E2AE)),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Text(
                                                  snapshot.data['data'][index]
                                                      ['nama'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            namacourse == ''
                                ? DataNull(txt: 'Pilih course!')
                                : FutureBuilder(
                                    future: getPengumpulan(),
                                    builder: (context, snapshott) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CircularProgressIndicator(
                                              color: Color(0xff85CBCB),
                                            ),
                                          ],
                                        );
                                      } else if (snapshott.hasData) {
                                        return snapshott.data['message'] ==
                                                'Berhasil mendapatkan data'
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshott
                                                    .data['data'].length,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10,
                                                            left: 10,
                                                            bottom: 5),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          id = snapshott
                                                              .data['data']
                                                                  [index][
                                                                  'pengumpulan_id']
                                                              .toString();
                                                        });
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return PopUp(
                                                                  title:
                                                                      'Detail',
                                                                  form: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Judul(
                                                                          txt:
                                                                              'Detail Tugas'),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        'Materi',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        snapshott.data['data'][index]
                                                                            [
                                                                            'judul'],
                                                                      ),
                                                                      Text(
                                                                        'Tugas',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        snapshott.data['data'][index]
                                                                            [
                                                                            'tugas'],
                                                                      ),
                                                                      Text(
                                                                        'Deadline',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        snapshott.data['data'][index]
                                                                            [
                                                                            'deadline'],
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Judul(
                                                                          txt:
                                                                              'Detail Pengumpulan'),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        'Waktu Pengumpulan',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        snapshott.data['data'][index]
                                                                            [
                                                                            'wkt_pengumpulan'],
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'Pelajar',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        snapshott.data['data'][index]['nama_user'] +
                                                                            ' (' +
                                                                            snapshott.data['data'][index]['user_id'].toString() +
                                                                            ')',
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        'Jawaban:',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      snapshott.data['data'][index]['foto'] ==
                                                                              'no'
                                                                          ? Text(
                                                                              snapshott.data['data'][index]['text'],
                                                                            )
                                                                          : Image.network(currentUrl +
                                                                              'images/' +
                                                                              snapshott.data['data'][index]['foto']),
                                                                      SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Judul(
                                                                          txt:
                                                                              'Beri Nilai'),
                                                                      snapshott.data['data'][index]['nilai'] ==
                                                                              'no'
                                                                          ? Form(
                                                                              key: _formKey,
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: width / 4,
                                                                                    padding: EdgeInsets.zero,
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.number,
                                                                                      inputFormatters: <TextInputFormatter>[
                                                                                        FilteringTextInputFormatter.digitsOnly
                                                                                      ],
                                                                                      controller: _nilai..text,
                                                                                      style: TextStyle(fontSize: 30),
                                                                                      textAlign: TextAlign.center,
                                                                                      cursorColor: Colors.black,
                                                                                      maxLength: 3,
                                                                                      decoration: InputDecoration(
                                                                                        hintText: '100',
                                                                                        border: InputBorder.none,
                                                                                        contentPadding: EdgeInsets.zero,
                                                                                        focusedBorder: InputBorder.none,
                                                                                        counterText: '',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      setnilai();
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff85CBCB)),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(10),
                                                                                        child: Text(
                                                                                          'Nilai',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Text('Sudah dinilai, ' + snapshott.data['data'][index]['nilai'].toString()),
                                                                              ],
                                                                            )
                                                                    ],
                                                                  ));
                                                            });
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.2),
                                                                      blurRadius:
                                                                          2,
                                                                      spreadRadius:
                                                                          0.5,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              1))
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff85CBCB),
                                                                child: Icon(
                                                                  Icons
                                                                      .assignment,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Materi',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    Text(
                                                                      snapshott.data['data']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'judul'],
                                                                      style: TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    Text(
                                                                      'Tugas',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    Text(
                                                                      snapshott.data['data']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'tugas'],
                                                                      style: TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    Text(
                                                                      'Pelajar',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    Text(
                                                                      snapshott.data['data'][index]
                                                                              [
                                                                              'nama_user'] +
                                                                          ' (' +
                                                                          snapshott
                                                                              .data['data'][index]['user_id']
                                                                              .toString() +
                                                                          ')',
                                                                      style: TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      width / 5,
                                                                  width:
                                                                      width / 5,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.2)),
                                                                  child: snapshott.data['data'][index]
                                                                              [
                                                                              'foto'] ==
                                                                          'no'
                                                                      ? Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'Jawaban:',
                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              Text(
                                                                                snapshott.data['data'][index]['text'],
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontSize: 12),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5),
                                                                          child: Image.network(currentUrl +
                                                                              'images/' +
                                                                              snapshott.data['data'][index]['foto']),
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : DataNull(
                                                txt: snapshott.data['message']);
                                      } else {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CircularProgressIndicator(
                                              color: Color(0xff85CBCB),
                                            ),
                                          ],
                                        );
                                      }
                                    })
                          ],
                        )
                      : DataNull(txt: snapshot.data['message']);
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        color: Color(0xff85CBCB),
                      ),
                    ],
                  );
                }
              }),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
