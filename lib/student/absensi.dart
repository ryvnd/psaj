import 'dart:convert';

import 'package:kelas_king_fe/model/container.dart';
import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/other.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Absensi extends StatefulWidget {
  final Map datauser;
  Absensi({required this.datauser});

  @override
  State<Absensi> createState() => _AbsensiState();
}

class _AbsensiState extends State<Absensi> {
  String waktu = '';
  String hari = '';
  String tanggal = '';
  String bulan = '';
  String tahun = '';
  @override
  void initState() {
    super.initState();
    _date();
  }

  void _date() {
    final String formattedWaktu = DateFormat('HH:mm').format(DateTime.now());
    final String formattedHari =
        DateFormat('EEEE', 'id_ID').format(DateTime.now());
    final String formattedTanggal =
        DateFormat('dd', 'id_ID').format(DateTime.now());
    final String formattedBulan =
        DateFormat('MMMM', 'id_ID').format(DateTime.now());
    final String formattedTahun =
        DateFormat('yyyy', 'id_ID').format(DateTime.now());

    setState(() {
      waktu = formattedWaktu;
      hari = formattedHari;
      tanggal = formattedTanggal;
      bulan = formattedBulan;
      tahun = formattedTahun;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future getRekap() async {
      try {
        var response = await http.get(Uri.parse(currentUrl +
            'api/get-rekap-absen-pelajar/' +
            widget.datauser['data']['id'].toString()));
        return json.decode(response.body);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return Eror(txt: e.toString());
            });
      }
    }

    Future getAbsenStudent() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/get-absen-today/' +
              widget.datauser['data']['id'].toString() +
              '/' +
              hari +
              '/' +
              tanggal +
              '/' +
              bulan +
              '/' +
              tahun),
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

    //function
    Widget sudahbelum(String pesan, snapshot) {
      if (pesan == 'Kamu sudah absen semua') {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Judul(txt: 'Belum absen'),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DataNull(txt: pesan),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Judul(txt: 'Sudah absen'),
              ),
              SizedBox(
                  height: width / 2.2,
                  child: ContainerAbsen(
                      date: hari + ', ' + tanggal + ' ' + bulan + ' ' + tahun,
                      datauser: widget.datauser,
                      message: snapshot.data['message'],
                      snapshot: snapshot,
                      w: 2.2,
                      color: Colors.green)),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      } else if (pesan == 'Kamu belum absen semua') {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Judul(txt: 'Belum absen'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                    height: width / 2.2,
                    child: ContainerAbsen(
                        date: hari + ', ' + tanggal + ' ' + bulan + ' ' + tahun,
                        datauser: widget.datauser,
                        message: snapshot.data['message'],
                        snapshot: snapshot,
                        w: 1.6,
                        color: Colors.red)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Judul(txt: 'Sudah absen'),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DataNull(txt: pesan),
              )
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Judul(txt: 'Belum absen'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                    height: width / 2.2,
                    child: ContainerAbsen(
                        date: hari + ', ' + tanggal + ' ' + bulan + ' ' + tahun,
                        datauser: widget.datauser,
                        message: snapshot.data['message'],
                        snapshot: snapshot,
                        w: 1.6,
                        color: Colors.red)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Judul(txt: 'Sudah absen'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 10),
                child: SizedBox(
                    height: width / 2.2,
                    child: ContainerAbsen(
                        date: hari + ', ' + tanggal + ' ' + bulan + ' ' + tahun,
                        datauser: widget.datauser,
                        message: snapshot.data['message'],
                        snapshot: snapshot,
                        w: 2.2,
                        color: Colors.green)),
              )
            ],
          ),
        );
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
          Container(
            decoration:
                BoxDecoration(color: Color(0xffA8DEE0).withOpacity(0.3)),
            child: Column(
              children: [
                Image.asset('images/top.png'),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, left: 20, right: 20, top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              hari,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                            Text(
                              tanggal + ' ' + bulan + ' ' + tahun,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width / 5,
                      ),
                      FutureBuilder(
                          future: getRekap(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print(snapshot.data);
                              return Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius: width / 60,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('Hadir'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: width / 60,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            snapshot.data['masuk'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.yellow,
                                          radius: width / 60,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('Izin'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: width / 60,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            snapshot.data['izin'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: width / 60,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('Sakit'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: width / 60,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            snapshot.data['sakit'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Text('...');
                            }
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: getAbsenStudent(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data['message'] != 'Tidak ada absen hari ini'
                      ? sudahbelum(snapshot.data['message'], snapshot)
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
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
              }),
        ],
      ),
    );
  }
}
