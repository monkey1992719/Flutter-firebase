import 'dart:async';
import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_anywhere/screens/order/create/create_order_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class CreateOrderScreen extends StatefulWidget {

  final CreateOrderViewModel viewModel;

  CreateOrderScreen({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {

  final formKey = new GlobalKey<FormState>();
  TextEditingController instructionsController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> mapController = Completer();
  TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    instructionsController = TextEditingController(
        text: widget.viewModel.instructions
    );
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

  void _onMapCreated(GoogleMapController controller) {
//    var startLocation = widget.viewModel.location ?? LatLng(-150, 37);
//    controller.animateCamera(CameraUpdate.newLatLngZoom(startLocation, 17.0));
    mapController.complete(controller);
  }

  Container _locationMap() {
    Size size = MediaQuery.of(context).size;
    double abovePadding = MediaQuery.of(context).padding.top;
    double screenHeight = size.height;
    double remainingHeight = screenHeight - abovePadding;
    double locationMapHeight = remainingHeight * 0.3;
    var startLocation = widget.viewModel.location ?? LatLng(-150, 37);
    return Container(
        height: locationMapHeight,
        child: Container(
            decoration: new BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1, color: Colors.grey.shade500),
                  top: BorderSide(width: 1, color: Colors.grey.shade500),
                  right: BorderSide(width: 1, color: Colors.grey.shade500),
                  bottom: BorderSide(width: 1, color: Colors.grey.shade500),
                ),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: StoreConnector<AppState, AppState>(
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
                          }),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Scrollbar(
            child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              child: Column(
                children: <Widget>[
                  _showForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showAppDescription(),
              _locationMap(),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              showInstructionsInput(),
              showPrimaryButton(),
              showSecondaryButton(),
            ],
          ),
        ));
  }

  Widget showInstructionsInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        controller: this.instructionsController,
        keyboardType: TextInputType.multiline,
        autofocus: false,
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Instructions for the photographer',
        ),
        maxLines: 8,
        minLines: 4,
      ),
    );
  }

  Widget showSecondaryButton() {
    return new OutlineButton(
        borderSide: BorderSide(width: 1, color: Colors.black26),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0)
        ),
        child: new Text('Cancel',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400)
        ),
        onPressed: () { Navigator.pop(context); },
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 12.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: Colors.blue,
            child: new Text('Next',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
                createOrder();
              }
            ),
          ),
        );
  }

  Widget _showAppDescription() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Order Photographs',
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Text(
            'To hire a freelancer to photograph your chosen location, '
                'please fill out the form below. You will be prompted '
                'for payment on the following screen.',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
                fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          ),
          Text(
            'Place to be Photographed',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          showPlaceToBePhotographed(),
          Padding(
            padding: EdgeInsets.all(4),
          ),
        ],
      ),
    );
  }

  Widget showPlaceToBePhotographed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(4),
          ),
          Text(
            this.widget.viewModel.address,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal),
          ),
//          Padding(
//            padding: EdgeInsets.all(4),
//          ),
//          Text(
//            formatLatitude(this.widget.viewModel.location),
//            style: TextStyle(
//                fontFeatures: [
//                  FontFeature.tabularFigures()
//                ],
//                fontSize: 14.0,
//                fontWeight: FontWeight.normal),
//          ),
//          Padding(
//            padding: EdgeInsets.all(4),
//          ),
//          Text(
//            formatLongitude(this.widget.viewModel.location),
//            style: TextStyle(
//                fontFeatures: [
//                  FontFeature.tabularFigures()
//                ],
//                fontSize: 14.0,
//                fontWeight: FontWeight.normal),
//          ),
//          Padding(
//            padding: EdgeInsets.all(4),
//          ),
        ],
    );
  }

  void createOrder() {
    this.widget.viewModel.onCreateOrder(
        new CreateOrderViewModel().initialize(
            this.widget.viewModel.address,
            this.instructionsController.text,
            this.widget.viewModel.location)
    );
  }

  String formatLatitude(LatLng location) {
    return location.latitude >= 0
        ? location.latitude.toString() + ' N'
        : location.latitude.toString().substring(1) + ' S';
  }

  String formatLongitude(LatLng location) {
    return location.longitude >= 0
        ? location.longitude.toString() + ' E'
        : location.longitude.toString().substring(1) + ' W';
  }
}
