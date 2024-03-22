import 'dart:convert';
import 'package:kelas_king_fe/model/null.dart';
import 'package:kelas_king_fe/model/show.dart';
import 'package:kelas_king_fe/url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PopUpAnggota extends StatelessWidget {
  final Map datacourse;
  PopUpAnggota({
    required this.datacourse,
  });
  @override
  Widget build(BuildContext context) {
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;

    //future
    Future getCourseMember() async {
      try {
        var response = await http.get(
          Uri.parse(currentUrl +
              'api/get-member/' +
              datacourse['id'].toString()),
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

    return PopUp(
        title: "Anggota",
        form: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FutureBuilder(
                future: getCourseMember(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data['message'] ==
                            "Berhasil mendapatkan data"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data['data'].length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            radius: 12,
                                            child: Icon(
                                              Icons.people,
                                              size: 15,
                                            )),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data['data'][index]
                                                    ['nama'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(snapshot.data['data'][index]
                                                  ['email'])
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : DataNull(txt: snapshot.data["message"]);
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xff85CBCB),
                          ),
                        ],
                      ),
                    );
                  }
                })));
  }
}
