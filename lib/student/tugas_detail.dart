import 'dart:convert';
import 'dart:io';

import 'package:kelas_king_fe/bnb.dart';
import 'package:kelas_king_fe/model/button.dart';
import 'package:kelas_king_fe/model/other.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TugasDetail extends StatefulWidget {
  final Map datatugas;
  final Map datauser;
  String idx;
  TugasDetail(
      {required this.datatugas, required this.datauser, required this.idx});

  @override
  State<TugasDetail> createState() => _TugasDetailState();
}

class _TugasDetailState extends State<TugasDetail> {
  File? _image;

  final _picker = ImagePicker();

  TextEditingController _submitController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _select = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future _openImagePicker(ImageSource img) async {
      final XFile? pickedImage = await _picker.pickImage(source: img);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    }

    Future pengumpulanTugasFoto(String waktu) async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var request = http.MultipartRequest(
            'POST', Uri.parse(currentUrl + 'api/tugas/pengumpulan-tugas-foto'));
        request.fields["tugas_id"] = widget.datatugas['id'].toString();
        request.fields["user_id"] = widget.datauser['data']['id'].toString();
        request.fields["wkt_pengumpulan"] = waktu;
        request.fields["text"] = 'no';
        request.files
            .add(await http.MultipartFile.fromPath("foto", _image!.path));
        var response = await request.send();
        var responsed = await http.Response.fromStream(response);
        Map data = json.decode(responsed.body);
        String message = data['message'];
        if (message == "Berhasil menambahkan data") {
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

    Future pengumpulanTugas(String waktu) async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var response = await http
            .post(Uri.parse(currentUrl + 'api/pengumpulan-tugas'), body: {
          "tugas_id": widget.datatugas['id'].toString(),
          "user_id": widget.datauser['data']['id'].toString(),
          "wkt_pengumpulan": waktu,
          "text": _submitController.text,
          "foto": 'no'
        });
        Map data = json.decode(response.body);
        String message = data['message'];
        if (message == 'Berhasil menambahkan data') {
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

    Future getbyid() async {
      try {
        var response = await http.get(Uri.parse(currentUrl +
            'api/tugas/getbyuser/' +
            widget.datatugas['id'].toString() +
            '/' +
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Text(
          'Tugas ' + widget.idx,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container()),
              Image.asset(
                'images/bgdown.png',
                height: height / 4,
                width: width,
                fit: BoxFit.fill,
              ),
            ],
          ),
          FutureBuilder(
              future: getbyid(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Judul(txt: 'Materi'),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 8, bottom: 10),
                                child: Text(widget.datatugas['judul']),
                              ),
                              Judul(txt: 'Tugas'),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 8, bottom: 10),
                                child: Text(widget.datatugas['tugas']),
                              ),
                              Judul(txt: 'Deadline'),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      widget.datatugas['deadline'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              snapshot.data['message'] ==
                                      'Belum mengumpulkan tugas'
                                  ? Column(children: [
                                      _select == true
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _select = !_select;
                                                    });
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Color(0xff85CBCB),
                                                    child: Icon(
                                                      Icons.image,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    maxLines: 5,
                                                    controller:
                                                        _submitController,
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        hintText:
                                                            "Pengumpulan tugas",
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black))),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "isi pengumpulan!";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _select = !_select;
                                                    });
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Color(0xff85CBCB),
                                                    child: Icon(
                                                      Icons.description,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Expanded(
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  shadowColor:
                                                                      Colors
                                                                          .transparent,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Column(
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      _openImagePicker(ImageSource.camera);
                                                                                    },
                                                                                    child: CircleAvatar(
                                                                                      backgroundColor: Color(0xff85CBCB),
                                                                                      child: Icon(
                                                                                        Icons.camera,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    'Kamera',
                                                                                    style: TextStyle(fontSize: 13),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      _openImagePicker(ImageSource.gallery);
                                                                                    },
                                                                                    child: CircleAvatar(
                                                                                      backgroundColor: Color(0xff85CBCB),
                                                                                      child: Icon(
                                                                                        Icons.photo,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    'Galeri',
                                                                                    style: TextStyle(fontSize: 13),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                        child: _image == null
                                                            ? Container(
                                                                height:
                                                                    width / 1.5,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .camera_alt,
                                                                      size:
                                                                          width /
                                                                              4,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    Text(
                                                                      'Ambil Gambar',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.grey),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : Container(
                                                                height:
                                                                    width / 1.5,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                child:
                                                                    Image.file(
                                                                        _image!),
                                                              )))
                                              ],
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Button(
                                            txt: 'Kumpulkan',
                                            color: Color(0xff85CBCB),
                                            shadow: Color(0xffA8DEE0),
                                            op: () async {
                                              if (_select) {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  pengumpulanTugas(DateFormat(
                                                          'dd/MM/yyyy hh:mm')
                                                      .format(DateTime.now()));
                                                }
                                              } else {
                                                if (_image == null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Eror(
                                                            txt:
                                                                'Ambil Gambar!');
                                                      });
                                                } else {
                                                  pengumpulanTugasFoto(
                                                      DateFormat(
                                                              'dd/MM/yyyy hh:mm')
                                                          .format(
                                                              DateTime.now()));
                                                }
                                              }
                                            }),
                                      )
                                    ])
                                  : Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: width / 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Nilai: ',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              snapshot.data['data'][0]
                                                          ['nilai'] ==
                                                      'no'
                                                  ? Text(
                                                      'Belum Dinilai',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )
                                                  : Text(
                                                      snapshot.data['data'][0]
                                                          ['nilai'],
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        CircularProgressIndicator(
                          color: Color(0xff85CBCB),
                        )
                      ],
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}
