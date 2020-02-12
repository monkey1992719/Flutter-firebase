import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/setting/settings_screen.dart';
import 'package:photo_anywhere/screens/setting/settings_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class SettingsConnector extends StatelessWidget {
  SettingsConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
      model: SettingsViewModel(),
      builder: (BuildContext context, SettingsViewModel vm) => SettingsScreen(
        viewModel: vm,
      ),
    );
  }
}
