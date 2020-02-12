import 'dart:async';
import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_anywhere/screens/home/home_view_model.dart';
import 'package:photo_anywhere/screens/order/create/create_order_connector.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class HomeScreen extends StatefulWidget {

  final HomeViewModel viewModel;

  HomeScreen({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> mapController = Completer();
  TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.viewModel.address);
    var startLocation = widget.viewModel.location ?? LatLng(-150, 37);
    final MarkerId markerId = MarkerId("RANDOM_ID");
    Marker marker = Marker(
      markerId: markerId,
      draggable: true,
      position: startLocation,
      infoWindow: InfoWindow(
        title: widget.viewModel.address,
        snippet: widget.viewModel.location.toString(),
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    markers[markerId] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Scrollbar(
            child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              child: Column(
                children: <Widget>[
                  _locationMap(),
                  _locationSearch(),
                  //ShowcaseCarousel(),
                  _placeOrderButton(),
                ],
              ),
            ),
          ),
        ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    var startLocation = widget.viewModel.location ?? LatLng(-150, 37);
    controller.animateCamera(CameraUpdate.newLatLngZoom(startLocation, 17.0));
    mapController.complete(controller);
  }

  Container _locationMap() {
    Size size = MediaQuery.of(context).size;
    double abovePadding = MediaQuery.of(context).padding.top;
    double screenHeight = size.height;
    double remainingHeight = screenHeight - abovePadding;
    double locationMapHeight = remainingHeight * 0.6;
    var startLocation = widget.viewModel.location ?? LatLng(-150, 37);
    return Container(
        height: locationMapHeight,
        child: Container(
            decoration: new BoxDecoration(
                border: Border(
                    bottom:
                    BorderSide(width: 2.0, color: Colors.grey.shade400))),
            child: FutureBuilder(
                future: Geolocator()
                    .getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
                builder: (context, AsyncSnapshot<Position> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return new Center();
                      }
                      return StoreConnector<AppState, AppState>(
                          converter: (store) => store.state,
                          builder: (context, state) {
                            return GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: startLocation,
                                zoom: 16.0,
                              ),
                              mapToolbarEnabled: true,
                              myLocationButtonEnabled: true,
                              rotateGesturesEnabled: true,
                              scrollGesturesEnabled: true,
                              tiltGesturesEnabled: true,
                              zoomGesturesEnabled: true,
                              markers: Set<Marker>.of(markers.values),
                            );
                          });
                    default:
                      return Center(child: CircularProgressIndicator());
                  }
                }
            )));
  }

  Container _locationSearch() {
    return Container(
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(14, 4, 22, 14),
            child: TextFormField(
                controller: this.addressController,
                decoration: InputDecoration(
                  icon: Icon(Icons.location_on),
                  labelText: 'Place to Get Photographed',
                ),
//              onEditingComplete: () => widget.viewModel.onLocationChanged(
//                  new HomeViewModel().initialize(
//                    this.addressController.text,
//                    null
//                  )
//              ),
              style: new TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  backgroundColor: null),
              strutStyle: StrutStyle(
                height: 0.1,
              ),
            ),
          ),
        ]));
  }

  Container _placeOrderButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 40.0,
            child: RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0)),
              color: Colors.blue,
              child: new Text('Order Photographs',
                  style: new TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateOrderConnector()),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
