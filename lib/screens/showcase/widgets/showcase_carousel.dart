import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
        return Stack(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                  child: Text(
                      'Photography Showcase',
                      style: new TextStyle(
                        color: Colors.black45,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 75),
                  child: CarouselSlider(
                    items: _buildShowcaseCarouselItems(context, snapshot.data.documents),
                    aspectRatio: 8/9,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    onPageChanged: (index) {
                      setState(() {
                        //_current = index;
                      });
                    },
                  )
              ),
            ]
        );
      },
    );
  }

  List _buildShowcaseCarouselItems(BuildContext context, List<DocumentSnapshot> snapshots) {
    return snapshots.map((data) => _buildShowcaseCarouselItem(context, data)).toList();
  }

  Container _buildShowcaseCarouselItem(BuildContext context, DocumentSnapshot snapshot) {
    Completer<GoogleMapController> _controller = Completer();
    final showcaseItem = ShowcaseItem.fromSnapshot(snapshot);
    return 
      Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(children: <Widget>[
            Image.network(showcaseItem.imageUrl, fit: BoxFit.cover, width: 1000.0, height:200.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 260.0, horizontal: 20.0),
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

            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 20.0),
                    child: Text(
                      showcaseItem.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:0.0, right:0.0, bottom:0.0),
                    height: 150,
                    child: GoogleMap(
                      mapType: MapType.hybrid,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        bearing: 192.8334901395799,
                        target:  LatLng(showcaseItem.location.latitude, showcaseItem.location.longitude),
                        zoom: 5.0,
                      ),
                      mapToolbarEnabled: true,
                      myLocationButtonEnabled: true,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                    ),
                  ),

                  
                ],
              ),
            ),
          ]),
        ),
      );
  }

 
}
