import 'dart:convert';

import 'package:kelas_king_fe/model/container.dart';
import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Search extends StatefulWidget {
  Map datauser;
  Search({required this.datauser});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  Future? _searchFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_searchController.text);
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future getCourseByTeacherSearch() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/search-course-pengajar/' +
              widget.datauser['data']['id'].toString() +
              '/' +
              _searchController.text),
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
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Cari Course',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey)),
                        hintText: 'Cari Course',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchFuture = getCourseByTeacherSearch();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff85CBCB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _searchController.text == ''
                ? DataNull(txt: 'Masukkan nama course')
                : FutureBuilder(
                    future: _searchFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xff85CBCB),
                            ),
                          ],
                        );
                      } else if (snapshot.hasData) {
                        return snapshot.data['message'] ==
                                'Course berhasil didapatkan'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, bottom: 10),
                                child: ContainerCourse(
                                  datauser: widget.datauser,
                                  snapshot: snapshot,
                                  role: "Pengajar",
                                ),
                              )
                            : DataNull(txt: snapshot.data['message']);
                      } else {
                        return DataNull(txt: 'Klik icon search');
                      }
                    }),
          ],
        ),
      ),
    );
  }
}
