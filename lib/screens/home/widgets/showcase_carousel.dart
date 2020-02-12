import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/data/showcase_item.dart';

class ShowcaseCarousel extends StatefulWidget {

  ShowcaseCarousel({
    Key key,
  }) : super(key: key);

  @override
  _ShowcaseCarouselState createState() => _ShowcaseCarouselState();
}

class _ShowcaseCarouselState extends State<ShowcaseCarousel> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _buildShowcaseCarousel(context)
    );
  }

  Widget _buildShowcaseCarousel(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('showcase_items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        return CarouselSlider(
          items: _buildShowcaseCarouselItems(context, snapshot.data.documents),
          aspectRatio: 16/9,
          autoPlay: false,
          enlargeCenterPage: true,
          height: 160,
          viewportFraction: 0.8,
        );
      },
    );
  }

  List _buildShowcaseCarouselItems(BuildContext context, List<DocumentSnapshot> snapshots) {
    return snapshots.map((data) => _buildShowcaseCarouselItem(context, data)).toList();
  }

  Container _buildShowcaseCarouselItem(BuildContext context, DocumentSnapshot snapshot) {
    final showcaseItem = ShowcaseItem.fromSnapshot(snapshot);
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          Image.network(showcaseItem.imageUrl, fit: BoxFit.cover, width: 1000.0),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                showcaseItem.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
