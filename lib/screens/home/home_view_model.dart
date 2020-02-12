import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_anywhere/screens/home/home_actions.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class HomeViewModel extends BaseModel<AppState> {
  HomeViewModel();

  String address;
  LatLng location;
  ValueChanged<HomeViewModel> onLocationChanged;

  HomeViewModel initialize(
      String candidateAddress,
      LatLng candidateLocation) {
    this.address = candidateAddress;
    this.location = candidateLocation;
    return this;
  }

  HomeViewModel.build({
    @required this.address,
    @required this.location,
    @required this.onLocationChanged,
  }) : super (equals: [address, location]);

  @override
  HomeViewModel fromStore() => HomeViewModel.build(
    address: state.address,
    location: state.location,
    onLocationChanged: (HomeViewModel vm) => dispatch(LocationChangedAction(vm)),
  );
}
