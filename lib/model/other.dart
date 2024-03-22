import 'package:kelas_king_fe/url.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Judul extends StatelessWidget {
  final String txt;
  Judul({
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Color(0xffF9E2AE)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Text(
              txt,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class Cs extends StatefulWidget {
  const Cs({super.key});

  @override
  State<Cs> createState() => _CsState();
}

class _CsState extends State<Cs> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var urlProvider = Provider.of<UrlProvider>(context);
    var currentUrl = urlProvider.url;
    final List<Widget> foto = List.generate(5, (index) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              currentUrl + 'images/' + (index + 1).toString() + '.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    });
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: width / 2 - 10,
              width: width,
            ),
            DotsIndicator(
              decorator: DotsDecorator(
                color: Colors.black.withOpacity(0.1),
                activeColor: Colors.black.withOpacity(0.7),
              ),
              dotsCount: foto.length,
              position: currentIndex,
            ),
          ],
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: width / 2,
            autoPlay: true,
            aspectRatio: 5 / 5,
            autoPlayAnimationDuration: Duration(milliseconds: 700),
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: foto,
        ),
      ],
    );
  }
}
