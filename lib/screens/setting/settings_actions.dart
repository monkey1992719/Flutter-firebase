import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_anywhere/screens/setting/settings_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class SaveSettingsAction extends ReduxAction<AppState> {

  final SettingsViewModel viewModel;

  SaveSettingsAction(this.viewModel);

  @override
  Future<AppState> reduce() async {

    // Mark start of save settings action reducer.
    debugPrint("Start of reducer function in SaveSettingsAction.");

    // Get logged in user.
    var user = await FirebaseAuth.instance.currentUser();

    // Find location from address.
    var location = await getLocation(this.viewModel.address);

    // Save address history.
    saveAddressHistory(this.viewModel.address, location, user);

    // Save user details.
    saveUserDetails(
        this.viewModel.firstName,
        this.viewModel.lastName,
        this.viewModel.address,
        location,
        user,
    );

    // Mark end of save settings action reducer.
    debugPrint("End of reducer function in SaveSettingsAction.");

    // Return state with updated values.
    return state.copy(
      address: this.viewModel.address,
      firstName: this.viewModel.firstName,
      lastName: this.viewModel.lastName,
      location: LatLng(location.latitude, location.longitude),
    );
  }

  Future<GeoPoint> getLocation(String address) async {
    try {
      var results = await Geocoder.local.findAddressesFromQuery(
          this.viewModel.address);
      return GeoPoint(
          results.first.coordinates.latitude,
          results.first.coordinates.longitude,
      );
    } on Exception {
      throw UserException('Address not recognized by Google location service.');
    }
  }

  saveAddressHistory(String address, GeoPoint location, FirebaseUser user) {
    try {
      Firestore.instance
          .collection('address_history')
          .add({
        "address": address,
        "date_created": FieldValue.serverTimestamp(),
        "location": location,
        "user_id": user.uid,
      });
    } on Exception catch (ex) {
      throw UserException('Address save failed: $ex');
    }
  }

  saveUserDetails(
      String firstName,
      String lastName,
      String defaultAddress,
      GeoPoint location,
      FirebaseUser user) {
    try {
      Firestore.instance
          .collection("users")
          .document(user.uid)
          .updateData({
            "first_name": firstName,
            "last_name": lastName,
            "address": defaultAddress,
            "location": location,
            "date_updated": FieldValue.serverTimestamp(),
      });
    } on Exception catch (ex) {
      throw UserException('User save failed: $ex');
    }
  }

  @override
  Object wrapError(error) => UserException("Save Settings Failed", cause: error);
}

class SignOutAction extends ReduxAction<AppState> {

  final SettingsViewModel viewModel;

  SignOutAction(this.viewModel);

  @override Future<AppState> reduce() async {

    //
    await this.viewModel.auth.signOut();
    //this.viewModel.auth.logoutCallback();

    //
    return state.copy(
      auth: null,
    );
  }
}