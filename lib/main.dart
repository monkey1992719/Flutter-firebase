import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/root_screen.dart';
import 'package:photo_anywhere/screens/auth/auth.dart';
import 'package:photo_anywhere/shared/app_state.dart';
import 'package:photo_anywhere/shared/menu.dart';

import 'shared/app_state.dart';

//final navigatorKey = GlobalKey<NavigatorState>();

Store<AppState> store;

void main() {
//  NavigateAction.setNavigatorKey(navigatorKey);
  var state = AppState.initialState();
  store = Store<AppState>(initialState: state);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: RootPage(auth: new Auth()),
//        navigatorKey: navigatorKey,
        title: 'Photo Anywhere',
      )
    );
  }
}
