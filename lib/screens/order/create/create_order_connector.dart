import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/order/create/create_order_screen.dart';
import 'package:photo_anywhere/screens/order/create/create_order_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class CreateOrderConnector extends StatelessWidget {
  CreateOrderConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateOrderViewModel>(
      model: CreateOrderViewModel(),
      builder: (BuildContext context, CreateOrderViewModel vm) => CreateOrderScreen(
        viewModel: vm,
      ),
    );
  }
}
