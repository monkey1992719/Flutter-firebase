import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class OrderViewModel extends BaseModel<AppState> {
  OrderViewModel();

  String userId;

  OrderViewModel initialize() {
    FirebaseAuth.instance.currentUser().then((user) {
      this.userId = user.uid;
    });
    return this;
  }

  OrderViewModel.build({
    @required this.userId,
  }) : super (equals: [userId]);

  @override
  OrderViewModel fromStore() => OrderViewModel.build(
    userId: state.user?.uid,
  );
}
