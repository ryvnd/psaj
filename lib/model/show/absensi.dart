import 'dart:convert';

import 'package:kelas_king_fe/bnb.dart';
import 'package:kelas_king_fe/model/button.dart';
import 'package:kelas_king_fe/model/other.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class PopUpAbsensi extends StatefulWidget {
  Map? datacourse;
  final Map datauser;
  String? id;
  PopUpAbsensi({
    this.datacourse,
    required this.datauser,
    this.id,
  });

  @override
  State<PopUpAbsensi> createState() => _PopUpAbsensiState();
}

class _PopUpAbsensiState extends State<PopUpAbsensi> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _jamstart = TextEditingController();

  TextEditingController _menitstart = TextEditingController();

  TextEditingController _jamend = TextEditingController();

  TextEditingController _menitend = TextEditingController();

  bool Seninv = false;

  bool Selasav = false;

  bool Rabuv = false;

  bool Kamisv = false;

  bool Jumatv = false;

  bool Sabtuv = false;

  bool Mingguv = false;

  String senin = '';

  String selasa = '';

  String rabu = '';

  String kamis = '';

  String jumat = '';

  String sabtu = '';

  String minggu = '';

  String warning = '';

  @override
  Widget build(BuildContext context) {
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future addJadwalabsenEnd() async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var response = await http
            .post(Uri.parse(currentUrl + 'api/add-jadwalabsen-end'), body: {
          "hari": senin + selasa + rabu + kamis + jumat + sabtu + minggu,
          "mulai": _jamstart.text + ":" + _menitstart.text,
          "selesai": _jamend.text + ":" + _menitend.text,
          "course_id": widget.id == null
              ? widget.datacourse!['id'].toString()
              : widget.id,
          "absen": "yes",
        });
        Map data = json.decode(response.body);
        String message = data['message'];
        if (message == 'Jadwal absen berhasil dibuat') {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Bnb(datauser: widget.datauser, idx: 1)));
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

    Future addJadwalabsen() async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var response = await http
            .post(Uri.parse(currentUrl + 'api/add-jadwalabsen'), body: {
          "hari": senin + selasa + rabu + kamis + jumat + sabtu + minggu,
          "mulai": _jamstart.text + ":" + _menitstart.text,
          "selesai": _jamend.text + ":" + _menitend.text,
          "course_id": widget.id == null
              ? widget.datacourse!['course_id'].toString()
              : widget.id,
        });
        Map data = json.decode(response.body);
        String message = data['message'];
        if (message == 'Jadwal absen berhasil dibuat') {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Bnb(datauser: widget.datauser, idx: 1)));
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
        title: "Buat Absensi",
        form: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Judul(txt: 'Hari'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: Color(0xff85CBCB),
                        visualDensity: VisualDensity(
                          horizontal: -4,
                        ),
                        value: Seninv,
                        onChanged: (v) {
                          setState(() {
                            Seninv = !Seninv;
                            if (Seninv) {
                              senin = 'Senin';
                            } else {
                              senin = '';
                            }
                          });
                        },
                        side: BorderSide(color: Colors.grey, width: 1.3),
                      ),
                      Text('Senin'),
                      SizedBox(
                        width: 8,
                      ),
                      Checkbox(
                        activeColor: Color(0xff85CBCB),
                        visualDensity: VisualDensity(
                          horizontal: -4,
                        ),
                        value: Selasav,
                        onChanged: (v) {
                          setState(() {
                            Selasav = !Selasav;
                            if (Selasav) {
                              selasa = 'Selasa';
                            } else {
                              selasa = '';
                            }
                          });
                        },
                        side: BorderSide(color: Colors.grey, width: 1.3),
                      ),
                      Text('Selasa'),
                      SizedBox(
                        width: 8,
                      ),
                      Checkbox(
                        activeColor: Color(0xff85CBCB),
                        visualDensity: VisualDensity(
                          horizontal: -4,
                        ),
                        value: Rabuv,
                        onChanged: (v) {
                          setState(() {
                            Rabuv = !Rabuv;
                            if (Rabuv) {
                              rabu = 'Rabu';
                            } else {
                              rabu = '';
                            }
                          });
                        },
                        side: BorderSide(color: Colors.grey, width: 1.3),
                      ),
                      Text('Rabu'),
                      SizedBox(
                        width: 8,
                      ),
                      Checkbox(
                        activeColor: Color(0xff85CBCB),
                        visualDensity: VisualDensity(
                          horizontal: -4,
                        ),
                        value: Kamisv,
                        onChanged: (v) {
                          setState(() {
                            Kamisv = !Kamisv;
                            if (Kamisv) {
                              kamis = 'Kamis';
                            } else {
                              kamis = '';
                            }
                          });
                        },
                        side: BorderSide(color: Colors.grey, width: 1.3),
                      ),
                      Text('Kamis'),
                      SizedBox(
                        width: 8,
                      ),
                      Checkbox(
                        activeColor: Color(0xff85CBCB),
                        visualDensity: VisualDensity(
                          horizontal: -4,
                        ),
                        value: Jumatv,
                        onChanged: (v) {
                          setState(() {
                            Jumatv = !Jumatv;
                            if (Jumatv) {
                              jumat = 'Jumat';
                            } else {
                              jumat = '';
                            }
                          });
                        },
                        side: BorderSide(color: Colors.grey, width: 1.3),
                      ),
                      Text('Jumat'),
                      SizedBox(
                        width: 8,
                      ),
                      Checkbox(
                        activeColor: Color(0xff85CBCB),
                        visualDensity: VisualDensity(
                          horizontal: -4,
                        ),
                        value: Sabtuv,
                        onChanged: (v) {
                          Sabtuv = !Sabtuv;
                          setState(() {
                            if (Sabtuv) {
                              sabtu = 'Sabtu';
                            } else {
                              sabtu = '';
                            }
                          });
                        },
                        side: BorderSide(color: Colors.grey, width: 1.3),
                      ),
                      Text('Sabtu'),
                      SizedBox(
                        width: 8,
                      ),
                      Checkbox(
                        activeColor: Color(0xff85CBCB),
                        visualDensity: VisualDensity(
                          horizontal: -4,
                        ),
                        value: Mingguv,
                        onChanged: (v) {
                          setState(() {
                            Mingguv = !Mingguv;
                            if (Mingguv) {
                              minggu = 'Minggu';
                            } else {
                              minggu = '';
                            }
                          });
                        },
                        side: BorderSide(color: Colors.grey, width: 1.3),
                      ),
                      Text('Minggu'),
                    ],
                  ),
                ),
                Judul(txt: 'Waktu'),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Contoh = 09:07 sd 16:59',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 35,
                          padding: EdgeInsets.zero,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _jamstart,
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black,
                            maxLength: 2,
                            decoration: InputDecoration(
                              hintText: '01',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                        Text(
                          ':',
                          style: TextStyle(fontSize: 30),
                        ),
                        Container(
                          width: 35,
                          padding: EdgeInsets.zero,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _menitstart,
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black,
                            maxLength: 2,
                            decoration: InputDecoration(
                              hintText: '00',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('sd'),
                    Row(
                      children: [
                        Container(
                          width: 35,
                          padding: EdgeInsets.zero,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _jamend,
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black,
                            maxLength: 2,
                            decoration: InputDecoration(
                              hintText: '01',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                        Text(
                          ':',
                          style: TextStyle(fontSize: 30),
                        ),
                        Container(
                          width: 35,
                          padding: EdgeInsets.zero,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _menitend,
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black,
                            maxLength: 2,
                            decoration: InputDecoration(
                              hintText: '00',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  warning,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Button(
                    txt: 'Buat',
                    color: Color(0xff85CBCB),
                    shadow: Color(0xffA8DEE0),
                    op: () {
                      if ((Seninv ||
                              Selasav ||
                              Rabuv ||
                              Kamisv ||
                              Jumatv ||
                              Sabtuv ||
                              Mingguv) ==
                          false) {
                        setState(() {
                          warning = 'pilih hari!';
                        });
                      } else if (_jamstart.text == '' ||
                          _menitstart.text == '' ||
                          _jamend.text == '' ||
                          _menitend.text == '') {
                        setState(() {
                          warning = 'isi waktu!';
                        });
                      } else {
                        widget.datacourse != null
                            ? addJadwalabsenEnd()
                            : addJadwalabsen();
                      }
                    })
              ],
            )));
  }
}
