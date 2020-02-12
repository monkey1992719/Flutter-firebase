import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_anywhere/screens/order/create/create_order_actions.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class CreateOrderViewModel extends BaseModel<AppState> {
  CreateOrderViewModel();

  String address;
  String instructions;
  LatLng location;
  ValueChanged<CreateOrderViewModel> onCreateOrder;

  CreateOrderViewModel initialize(
      String address,
      String instructions,
      LatLng location,
      ) {
    this.address = address;
    this.instructions = instructions;
    this.location = location;
    return this;
  }

  CreateOrderViewModel.build({
    @required this.address,
    @required this.instructions,
    @required this.location,
    @required this.onCreateOrder,
  }) : super (equals: [address, instructions, location]);

  @override
  CreateOrderViewModel fromStore() => CreateOrderViewModel.build(
    address: state.address,
    instructions: state.instructions,
    location: state.location,
    onCreateOrder: (CreateOrderViewModel vm) => dispatch(CreateOrderAction(vm)),
  );
}
