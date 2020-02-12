import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/showcase/showcase_screen.dart';
import 'package:photo_anywhere/screens/showcase/showcase_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class ShowcaseConnector extends StatelessWidget {
  ShowcaseConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ShowcaseViewModel>(
      model: ShowcaseViewModel(),
      builder: (BuildContext context, ShowcaseViewModel vm) => ShowcaseScreen(
        viewModel: vm,
      ),
    );
  }
}
