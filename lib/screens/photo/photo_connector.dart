import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/photo/photo_screen.dart';
import 'package:photo_anywhere/screens/photo/photo_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class PhotoConnector extends StatelessWidget {
  PhotoConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PhotoViewModel>(
      model: PhotoViewModel(),
      builder: (BuildContext context, PhotoViewModel vm) => PhotoScreen(
        viewModel: vm,
      ),
    );
  }
}
