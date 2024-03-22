
import 'dart:convert';

import 'package:kelas_king_fe/bnb.dart';
import 'package:kelas_king_fe/model/container.dart';
import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/student/materi_detail.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/other.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CourseDetail extends StatefulWidget {
  final Map datacourse;
  final Map datauser;
  Color color;
  CourseDetail({
    required this.datacourse,
    required this.datauser,
    required this.color,
  });

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

final List<Color> colorr = [
  Color(0xffDEDAF4),
  Color(0xffD9EDF8),
  Color(0xffE4F1EE),
];

class _CourseDetailState extends State<CourseDetail> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future getMateri() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/get-materi/' +
              widget.datacourse['id'].toString()),
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
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: widget.color.withOpacity(0.7),
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          BgDetilCourse(nama: widget.datacourse['nama'], color: widget.color),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Container(
              width: width / 2.2,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 1,
                        offset: Offset(0, 1)),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: width / 18,
                      child: Icon(Icons.school),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengajar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Text(
                            widget.datacourse['namaguru'],
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff85CBCB)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Bnb(datauser: widget.datauser, idx: 1)));
                },
                child: Text('Absensi')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Judul(txt: 'Materi'),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
                  future: getMateri(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data['message'] ==
                              "Belum ada materi di course ini"
                          ? DataNull(txt: snapshot.data["message"])
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data['data'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MateriDetail(
                                                      datamateri: snapshot
                                                          .data['data'][index],
                                                      datauser:
                                                          widget.datauser)));
                                    },
                                    child: Column(children: [
                                      Container(
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: colorr[index % colorr.length],
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8)),
                                        ),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'images/top.png',
                                              fit: BoxFit.fill,
                                              width: width,
                                            ),
                                            Icon(
                                              Icons.book,
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                            ),
                                            Image.asset(
                                              'images/topp.png',
                                              fit: BoxFit.fill,
                                              width: width,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1))
                                            ],
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(8))),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.pink,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Center(
                                                    child: Text(
                                                      index < 9
                                                          ? '0' +
                                                              (index + 1)
                                                                  .toString()
                                                          : (index + 1)
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.9)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data['data']
                                                          [index]['judul'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      snapshot.data['data']
                                                          [index]['deskripsi'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Icon(Icons.assignment,
                                                  size: width / 20,
                                                  color: Colors.grey)
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
                                );
                              });
                    } else {
                      return Column(
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xff85CBCB),
                          )
                        ],
                      );
                    }
                  })),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
