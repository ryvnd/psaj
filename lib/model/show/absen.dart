import 'dart:convert';
import 'dart:io';

import 'package:kelas_king_fe/bnb.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AbsenShow extends StatefulWidget {
  final Map datauser;
  final String course_id;
  AbsenShow({
    required this.datauser,
    required this.course_id,
  });
  @override
  State<AbsenShow> createState() => _AbsenShowState();
}

class _AbsenShowState extends State<AbsenShow> {
  File? _image;

  final _picker = ImagePicker();

  String _selectedValue = '';

  void _handleRadioValueChanged(String? value) {
    setState(() {
      _selectedValue = value.toString();
    });
  }

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
    String date = hari + ', ' + tanggal + ' ' + bulan + ' ' + tahun;
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future doAbsen(String keterangan) async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var response =
            await http.post(Uri.parse(currentUrl + 'api/do-absen'), body: {
          "course_id": widget.course_id,
          "user_id": widget.datauser['data']['id'].toString(),
          "keterangan": keterangan,
          "hari": hari,
          "tanggal": tanggal,
          "bulan": bulan,
          "tahun": tahun,
          "waktu": waktu
        });
        Map data = json.decode(response.body);
        String message = data['message'];
        if (message == 'Absensi berhasil') {
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

    Future _openImagePicker(ImageSource img) async {
      final XFile? pickedImage = await _picker.pickImage(source: img);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    }

    Future doAbsenFoto(String keterangan) async {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return Wait();
            });
        var request = http.MultipartRequest(
            'POST', Uri.parse(currentUrl + 'api/do-absen'));
        request.fields['course_id'] = widget.course_id;
        request.fields['user_id'] = widget.datauser['data']['id'].toString();
        request.fields['keterangan'] = keterangan;
        request.fields['hari'] = hari;
        request.fields['tanggal'] = tanggal;
        request.fields['bulan'] = bulan;
        request.fields['tahun'] = tahun;
        request.fields['waktu'] = waktu;
        request.files.add(await http.MultipartFile.fromPath(
            keterangan == 'Izin' ? "surat_izin" : "surat_sakit", _image!.path));
        var response = await request.send();
        var responsed = await http.Response.fromStream(response);
        Map data = json.decode(responsed.body);
        String message = data['message'];
        if (message == 'Absensi berhasil') {
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

    //function
    pilihabsen() {
      if (_selectedValue == 'Masuk') {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xffA8DEE0).withOpacity(0.3),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(waktu),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6, left: 8, right: 8),
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _date();
                        doAbsen("Masuk");
                      });
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff85CBCB)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Kirim',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (_selectedValue == 'Izin') {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xffA8DEE0).withOpacity(0.3),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(waktu),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 8),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _openImagePicker(
                                                          ImageSource.camera);
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Color(0xff85CBCB),
                                                      child: Icon(
                                                        Icons.camera,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Kamera',
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _openImagePicker(
                                                          ImageSource.gallery);
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Color(0xff85CBCB),
                                                      child: Icon(
                                                        Icons.photo,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Galeri',
                                                    style:
                                                        TextStyle(fontSize: 13),
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
                                height: width / 1.5,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      size: width / 6,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Foto Surat Izin',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: width / 1.5,
                                width: width,
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_image != null) {
                        setState(() {
                          _date();
                          doAbsenFoto("Izin");
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Eror(txt: 'isi surat izin!');
                            });
                      }
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff85CBCB)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Kirim',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (_selectedValue == 'Sakit') {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xffA8DEE0).withOpacity(0.3),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(waktu),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 8),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _openImagePicker(
                                                          ImageSource.camera);
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Color(0xff85CBCB),
                                                      child: Icon(
                                                        Icons.camera,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Kamera',
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _openImagePicker(
                                                          ImageSource.gallery);
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Color(0xff85CBCB),
                                                      child: Icon(
                                                        Icons.photo,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Galeri',
                                                    style:
                                                        TextStyle(fontSize: 13),
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
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          shadowColor: Colors.transparent,
                                          backgroundColor: Colors.transparent,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              _openImagePicker(
                                                                  ImageSource
                                                                      .camera);
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xff85CBCB),
                                                              child: Icon(
                                                                Icons.camera,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Kamera',
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              _openImagePicker(
                                                                  ImageSource
                                                                      .gallery);
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xff85CBCB),
                                                              child: Icon(
                                                                Icons.photo,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Galeri',
                                                            style: TextStyle(
                                                                fontSize: 13),
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
                                child: Container(
                                  height: width / 1.5,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: width / 6,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Foto Surat Sakit',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                height: width / 1.5,
                                width: width,
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_image != null) {
                        setState(() {
                          _date();
                          doAbsenFoto("Sakit");
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Eror(txt: 'isi surat sakit!');
                            });
                      }
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff85CBCB)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Kirim',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'pilih absensi!',
            style: TextStyle(color: Colors.red, fontSize: 13),
          ),
        );
      }
    }

    return PopUp(
        title: "Absensi",
        form: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 18, left: 10, right: 10, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Radio(
                        value: 'Masuk',
                        activeColor: Color(0xff85CBCB),
                        groupValue: _selectedValue,
                        onChanged: _handleRadioValueChanged,
                        visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                      ),
                      Text(
                        'Masuk',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Radio(
                        value: 'Izin',
                        activeColor: Color(0xff85CBCB),
                        groupValue: _selectedValue,
                        onChanged: _handleRadioValueChanged,
                        visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                      ),
                      Text(
                        'Izin',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Radio(
                        value: 'Sakit',
                        activeColor: Color(0xff85CBCB),
                        groupValue: _selectedValue,
                        onChanged: _handleRadioValueChanged,
                        visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                      ),
                      Text(
                        'Sakit',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  )
                ],
              ),
            ),
            pilihabsen()
          ],
        ));
  }
}

// ignore: must_be_immutable
class DetailAbsen extends StatelessWidget {
  var data;
  String date;
  DetailAbsen({
    required this.data,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;
    return PopUp(
        title: "Detail Absensi",
        form: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(0.1)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Keterangan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(data['keterangan'])
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggal Absensi",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(date)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Waktu Absensi",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(data['waktu'])
                      ],
                    ),
                  )
                ],
              ),
              data['keterangan'] == "Masuk"
                  ? Container()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 8),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.green.withOpacity(0.1)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Surat',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ),
                        Image.network(currentUrl +
                            'images/' +
                            data[data['surat_izin'] == 'no'
                                ? 'surat_sakit'
                                : 'surat_izin'])
                      ],
                    ),
            ],
          ),
        ));
  }
}
