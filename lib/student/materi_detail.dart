import 'dart:convert';
import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/other.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/student/tugas_detail.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MateriDetail extends StatelessWidget {
  final Map datamateri;
  final Map datauser;
  MateriDetail({
    required this.datamateri,
    required this.datauser,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future getTugasPelajar() async {
      try {
        var response = await http.get(
          Uri.parse(
              currentUrl + 'api/get-tugas/' + datamateri['id'].toString()),
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
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Text(
            'Materi',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                  height: width / 2,
                  width: width,
                  color: Color(0xff85CBCB).withOpacity(0.2),
                  child: datamateri['foto'] != 'no'
                      ? Image.network(
                          currentUrl + 'images/' + datamateri['foto'])
                      : Image.asset('images/logo.png')),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 10, left: 10),
              child: Judul(txt: 'Judul materi'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                datamateri['judul'],
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
                  datamateri['tautan'] == 'no'
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
                                                            datamateri[
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
                                                                  //launchurl();
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
                                datamateri['tautan'],
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                  Text(
                    datamateri['deskripsi'],
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
                  future: getTugasPelajar(),
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
                                              builder: (context) => TugasDetail(
                                                  idx: (index + 1).toString(),
                                                  datauser: datauser,
                                                  datatugas: snapshot
                                                      .data['data'][index])));
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
