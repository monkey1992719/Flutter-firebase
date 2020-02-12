import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/order/order_screen.dart';
import 'package:photo_anywhere/screens/order/order_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class OrderConnector extends StatelessWidget {
  OrderConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderViewModel>(
      model: OrderViewModel().initialize(),
      builder: (BuildContext context, OrderViewModel vm) => OrderScreen(
        viewModel: vm,
      ),
    );
  }
}
