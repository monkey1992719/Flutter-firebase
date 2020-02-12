import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_anywhere/screens/auth/auth.dart';
import 'package:photo_anywhere/screens/setting/settings_actions.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class SettingsViewModel extends BaseModel<AppState> {
  SettingsViewModel();

  Auth auth;
  String address;
  String firstName;
  String lastName;
  LatLng location;
  ValueChanged<SettingsViewModel> onSaveSettings;

  SettingsViewModel initialize(
      Auth candidateAuth,
      String candidateAddress,
      String candidateFirstName,
      String candidateLastName) {
    this.auth = candidateAuth;
    this.address = candidateAddress;
    this.firstName = candidateFirstName;
    this.lastName = candidateLastName;
    return this;
  }

  SettingsViewModel.build({
    @required this.auth,
    @required this.address,
    @required this.firstName,
    @required this.lastName,
    @required this.location,
    @required this.onSaveSettings,
  }) : super (equals: [auth, address, firstName, lastName, location]);

  @override
  SettingsViewModel fromStore() => SettingsViewModel.build(
    auth: state.auth,
    address: state.address,
    firstName: state.firstName,
    lastName: state.lastName,
    location: state.location,
    onSaveSettings: (SettingsViewModel vm) => dispatch(SaveSettingsAction(vm)),
  );
}
