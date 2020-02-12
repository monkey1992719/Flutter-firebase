import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/home/home_screen.dart';
import 'package:photo_anywhere/screens/home/home_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class HomeConnector extends StatelessWidget {
  HomeConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      model: HomeViewModel(),
      builder: (BuildContext context, HomeViewModel vm) => HomeScreen(
        viewModel: vm,
      ),
    );
  }
}
