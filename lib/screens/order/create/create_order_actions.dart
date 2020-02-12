import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/order/create/create_order_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class CreateOrderAction extends ReduxAction<AppState> {

  final CreateOrderViewModel viewModel;

  CreateOrderAction(this.viewModel);

  @override
  Future<AppState> reduce() async {

    // Mark start of create order action reducer.
    debugPrint("Start of reducer function in CreateOrderAction.");

    // Get logged in user.
    var user = await FirebaseAuth.instance.currentUser();

    // Save order and retrieve its Firebase id.
    var orderId = saveOrder(user);

    // Navigate to screen of newly created order.
    NavigateAction.pop();

    // Mark end of create order action reducer.
    debugPrint("End of reducer function in CreateOrderAction.");

    // Return state with cleared values.
    return state.copy(
      address: '',
      instructions: '',
      location: null,
    );
  }

  String saveOrder(FirebaseUser user) {
    Firestore.instance
        .collection('orders')
        .add({
      "address": this.viewModel.address,
      "date_created": FieldValue.serverTimestamp(),
      "instructions": this.viewModel.instructions,
      "location": GeoPoint(
          this.viewModel.location.latitude,
          this.viewModel.location.longitude),
      "user_id": user.uid,
    }).then((DocumentReference doc) {
      return doc.documentID;
    });
  }
}
