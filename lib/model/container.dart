import 'package:kelas_king_fe/model/show/absen.dart';
import 'package:kelas_king_fe/student/course_detail.dart';
import 'package:kelas_king_fe/teacher/course_detail.dart';
import 'package:flutter/material.dart';

class ContainerCourse extends StatelessWidget {
  final List<Color> color = [
    Color(0xffDEDAF4),
    Color(0xffD9EDF8),
    Color(0xffE4F1EE),
  ];

  final snapshot;
  final String role;
  final Map datauser;
  ContainerCourse({
    required this.snapshot,
    required this.role,
    required this.datauser,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: snapshot.data['data'].length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              role == 'Pelajar'
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseDetail(
                              color: color[index % color.length],
                              datauser: datauser,
                              datacourse: snapshot.data['data'][index])))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TCourseDetail(
                              datauser: datauser,
                              color: color[index % color.length],
                              datacourse: snapshot.data['data'][index])));
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: color[index % color.length],
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8))),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/top.png',
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: width / 15, left: 10),
                                child: Icon(
                                  Icons.book,
                                  size: width / 7,
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'images/bottom.png',
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 1,
                            offset: Offset(0, 1))
                      ],
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          snapshot.data['data'][index]['nama'],
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 6),
                              child: CircleAvatar(
                                radius: 12,
                                child: Icon(
                                  Icons.school,
                                  size: 15,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data['data'][index]['namaguru'],
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class BgDetilCourse extends StatelessWidget {
  final String nama;
  final Color color;
  BgDetilCourse({
    required this.nama,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        child: Column(
          children: [
            Image.asset('images/top.png'),
            Padding(
              padding: const EdgeInsets.only(
                  right: 10, left: 10, bottom: 30, top: 10),
              child: Text(
                nama,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Image.asset('images/bottom.png'),
          ],
        ));
  }
}

//containerabsen
// ignore: must_be_immutable
class ContainerAbsen extends StatelessWidget {
  final Color color;
  final Map datauser;
  var snapshot;
  var message;
  var w;
  String date;
  ContainerAbsen({
    required this.color,
    required this.snapshot,
    required this.w,
    required this.message,
    required this.datauser,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //function
    length() {
      if (message == "Data absen kamu" && w == 2.2) {
        return snapshot.data['sudahabsen'].length;
      } else if (message == "Data absen kamu" && w == 1.6) {
        return snapshot.data['belumabsen'].length;
      } else {
        return snapshot.data['data'].length;
      }
    }

    keteranganOrWaktu(index) {
      if (message == "Data absen kamu" && w == 2.2) {
        return snapshot.data['sudahabsen'][index]['keterangan'];
      } else if (message == "Data absen kamu" && w == 1.6) {
        String mulai = snapshot.data['belumabsen'][index]['mulai'];
        String selesai = snapshot.data['belumabsen'][index]['selesai'];
        return mulai + ' sd ' + selesai;
      } else if (message == "Kamu sudah absen semua") {
        return snapshot.data['data'][index]['keterangan'];
      } else if (message == "Kamu belum absen semua") {
        String mulai = snapshot.data['data'][index]['mulai'];
        String selesai = snapshot.data['data'][index]['selesai'];
        return mulai + ' sd ' + selesai;
      }
    }

    nama(index) {
      if (message == "Data absen kamu" && w == 2.2) {
        return snapshot.data['sudahabsen'][index]['nama'];
      } else if (message == "Data absen kamu" && w == 1.6) {
        return snapshot.data['belumabsen'][index]['nama'];
      } else {
        return snapshot.data['data'][index]['nama'];
      }
    }

    course_id(index) {
      if (message == "Data absen kamu" && w == 2.2) {
        return snapshot.data['sudahabsen'][index]['course_id'];
      } else if (message == "Data absen kamu" && w == 1.6) {
        return snapshot.data['belumabsen'][index]['course_id'];
      } else {
        return snapshot.data['data'][index]['course_id'];
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: length(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 5),
              child: Stack(
                children: [
                  Container(
                    height: width / 2.2,
                    width: width / w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: color.withOpacity(0.5)),
                  ),
                  Column(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'images/top.png',
                            width: width / w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              size: width / 7,
                              color: color.withOpacity(0.3),
                            ),
                          )
                        ],
                      )),
                      Container(
                        width: width / w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1,
                                  offset: Offset(0, 1))
                            ],
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(8))),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nama(index),
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      keteranganOrWaktu(index),
                                      style: TextStyle(
                                          color: w == 2.2
                                              ? Colors.black
                                              : Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return w == 2.2
                                                ? DetailAbsen(
                                                    date: date,
                                                    data: snapshot.data['data']
                                                        [index],
                                                  )
                                                : AbsenShow(
                                                    datauser: datauser,
                                                    course_id: course_id(index),
                                                  );
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: color),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 15),
                                        child: Text(
                                          w == 2.2 ? 'Detail' : 'Absen',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
