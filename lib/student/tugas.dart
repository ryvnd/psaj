import 'dart:convert';

import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/student/tugas_detail.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Tugas extends StatefulWidget {
  final Map datauser;
  Tugas({required this.datauser});

  @override
  State<Tugas> createState() => _TugasState();
}

class _TugasState extends State<Tugas> {
  String namacourse = '';
  String idc = '';
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future getCourseByStudent() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/get-course-pelajar/' +
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

    Future getCourseByCourse() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl + 'api/get-tugas-bycourse-pelajar/' + idc),
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
              future: getCourseByStudent(),
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
                                              idc = snapshot.data['data'][index]
                                                      ['course_id']
                                                  .toString();
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
                                    future: getCourseByCourse(),
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
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => TugasDetail(
                                                                    datatugas: snapshott
                                                                            .data['data']
                                                                        [index],
                                                                    datauser: widget
                                                                        .datauser,
                                                                    idx: (index +
                                                                            1)
                                                                        .toString())));
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
                                                                      'Tugas ' +
                                                                          (index + 1)
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        snapshott.data['data'][index]
                                                                            [
                                                                            'tugas'],
                                                                        style: TextStyle(
                                                                            overflow:
                                                                                TextOverflow.ellipsis),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        snapshott.data['data'][index]
                                                                            [
                                                                            'judul'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            overflow: TextOverflow.ellipsis),
                                                                      ),
                                                                    )
                                                                  ],
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
