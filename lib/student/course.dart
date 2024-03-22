import 'dart:convert';

import 'package:kelas_king_fe/model/container.dart';
import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/other.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/student/search.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Course extends StatefulWidget {
  final Map datauser;
  Course({required this.datauser});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  Widget build(BuildContext context) {
    //var width = MediaQuery.of(context).size.width;
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          'Course',
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
          Cs(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Judul(txt: 'Daftar Course'),
          ),
          FutureBuilder(
              future: getCourseByStudent(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data['message'] ==
                          "Course berhasil didapatkan"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PSearch(
                                                datauser: widget.datauser,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2, right: 5),
                                          child: Text(
                                            '|',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text('Cari course')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ContainerCourse(
                                datauser: widget.datauser,
                                snapshot: snapshot,
                                role: "Pelajar",
                              ),
                            ],
                          ),
                        )
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
              })),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
