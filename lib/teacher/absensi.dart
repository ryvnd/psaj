import 'dart:convert';

import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/other.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TAbsensi extends StatelessWidget {
  final Map datauser;
  TAbsensi({required this.datauser});
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future getRekapAbsenTeacher() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/get-absen-pengajar/' +
              datauser['data']['id'].toString()),
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

    Future getDetail(String id) async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl + 'api/get-rekapabsen-pengajar/' + id),
        );
        Map data = json.decode(response.body);
        String msg = data['message'];
        if (msg == 'Data berhasil didapatkan') {
          List dataa = data['data']
            ..map((item) => {
                  'id': item['id'].toString(),
                  'nama': item['nama'],
                  'keterangan': item['keterangan'],
                  'tanggal':
                      '${item['hari']}, ${item['tanggal']} ${item['bulan']} ${item['tahun']}',
                  'waktu': item['waktu'],
                  'surat_izin': item['surat_izin'],
                  'surat_sakit': item['surat_sakit']
                }).toList();
          return dataa;
        } else {
          return data['message'];
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
          'Absensi',
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
              child: datauser['data']['role'] == 'Pelajar'
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
          Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 10, bottom: 10, right: 10),
            child: Judul(txt: 'Daftar Absensi Course'),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
              child: FutureBuilder(
                  future: getRekapAbsenTeacher(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data['message'] ==
                              "Data berhasil didapatkan"
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data['data'].length,
                              itemBuilder: (context, index) {
                                String mulai =
                                    snapshot.data['data'][index]['mulai'];
                                String selesai =
                                    snapshot.data['data'][index]['selesai'];
                                String jam = mulai + ' - ' + selesai;
                                String hari =
                                    snapshot.data['data'][index]['hari'];
                                String hariFormatted = '';

                                for (var i = 0; i < hari.length; i++) {
                                  if (hari[i].codeUnitAt(0) >= 65 &&
                                      hari[i].codeUnitAt(0) <= 90) {
                                    if (i > 0) {
                                      hariFormatted += ', ';
                                    }
                                    hariFormatted += hari[i];
                                  } else {
                                    hariFormatted += hari[i];
                                  }
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.orangeAccent
                                            .withOpacity(0.4)),
                                    child: Column(
                                      children: [
                                        Image.asset('images/top.png'),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data['data']
                                                          [index]['nama'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(hariFormatted),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      jam,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return PopUp(
                                                            title:
                                                                "Rekap Absensi Pelajar",
                                                            form: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Judul(
                                                                    txt:
                                                                        'Data'),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                FutureBuilder(
                                                                    future: getDetail(snapshot
                                                                        .data[
                                                                            'data']
                                                                            [
                                                                            index]
                                                                            [
                                                                            'id']
                                                                        .toString()),
                                                                    builder:
                                                                        (context,
                                                                            snapshott) {
                                                                      if (snapshott
                                                                          .hasData) {
                                                                        return snapshott.data ==
                                                                                "Belum ada pelajar yang melakukan absensi"
                                                                            ? DataNull(txt: snapshott.data)
                                                                            : SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: DataTable(
                                                                                  headingRowColor: MaterialStateColor.resolveWith((states) => Color(0xffA8DEE0)),
                                                                                  columns: [
                                                                                    DataColumn(
                                                                                      label: Text('No'),
                                                                                    ),
                                                                                    DataColumn(label: Text('Nama Pelajar')),
                                                                                    DataColumn(label: Text('Keterangan')),
                                                                                    DataColumn(label: Text('Tanggal')),
                                                                                    DataColumn(label: Text('Waktu')),
                                                                                    DataColumn(label: Text('Lain-lain')),
                                                                                  ],
                                                                                  rows: snapshott.data.map<DataRow>((rowData) {
                                                                                    int index = snapshott.data.indexOf(rowData);

                                                                                    return DataRow(cells: [
                                                                                      DataCell(Text((index + 1).toString(), style: TextStyle(fontWeight: FontWeight.bold))),
                                                                                      DataCell(Text(rowData['nama']! + ' (' + rowData['id'].toString() + ')')),
                                                                                      DataCell(Text(rowData['keterangan']!)),
                                                                                      DataCell(Text('${rowData['hari']}, ${rowData['tanggal']} ${rowData['bulan']} ${rowData['tahun']}')),
                                                                                      DataCell(Text(rowData['waktu']!)),
                                                                                      DataCell(rowData['surat_izin'] != 'no' || rowData['surat_sakit'] != 'no'
                                                                                          ? GestureDetector(
                                                                                              onTap: () {
                                                                                                showDialog(
                                                                                                    context: context,
                                                                                                    builder: (context) {
                                                                                                      String ft = snapshott.data[index]['surat_izin'] == 'no' ? snapshott.data[index]['surat_sakit'] : snapshott.data[index]['surat_izin'];
                                                                                                      return PopUp(
                                                                                                          title: "Surat",
                                                                                                          form: Padding(
                                                                                                            padding: const EdgeInsets.only(top: 10),
                                                                                                            child: Image.network(
                                                                                                              currentUrl + 'images/' + ft,
                                                                                                            ),
                                                                                                          ));
                                                                                                    });
                                                                                              },
                                                                                              child: Text(
                                                                                                'Surat',
                                                                                                style: TextStyle(color: Colors.blue),
                                                                                              ),
                                                                                            )
                                                                                          : Text('-')),
                                                                                    ]);
                                                                                  }).toList(),
                                                                                ),
                                                                              );
                                                                      } else {
                                                                        return Column(
                                                                          children: [
                                                                            CircularProgressIndicator(
                                                                              color: Color(0xff85CBCB),
                                                                            )
                                                                          ],
                                                                        );
                                                                      }
                                                                    })
                                                              ],
                                                            ));
                                                      });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.green
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8,
                                                        horizontal: 15),
                                                    child: Text(
                                                      "Rekap Absensi Pelajar",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: DataNull(txt: snapshot.data['message']),
                            );
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          CircularProgressIndicator(
                            color: Color(0xff85CBCB),
                          )
                        ],
                      );
                    }
                  }))
        ],
      ),
    );
  }
}
