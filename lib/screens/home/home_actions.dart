import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_anywhere/screens/home/home_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class LocationChangedAction extends ReduxAction<AppState> {

  final HomeViewModel viewModel;

  LocationChangedAction(this.viewModel);

  @override
  Future<AppState> reduce() async {

    // Temp data.
    //String temp = "180 Montgomery St, San Francisco, CA 94104";

    debugPrint("Start of reducer function in SaveSettingsAction.");

    // Find location from address.
    var results = await Geocoder.local.findAddressesFromQuery(this.viewModel.address);
    var location = results.first.coordinates;

    debugPrint("Gelocated position: $location");

    // Add attempted address to Firebase (so we have history).
    Firestore.instance
        .collection('address_history')
        .add({
      "address": this.viewModel.address,
      "location": new GeoPoint(location.latitude, location.longitude),
    });

    debugPrint("Firebase call completed.");

    // Update user settings in Firebase.
    // TODO

    // Return state with updated values.
    return state.copy(
      address: this.viewModel.address,
      location: LatLng(location.latitude, location.longitude),
    );
  }
}
