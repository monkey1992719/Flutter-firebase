import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/auth/auth.dart';
import 'package:photo_anywhere/screens/home/home_connector.dart';
import 'package:photo_anywhere/screens/order/order_connector.dart';
import 'package:photo_anywhere/screens/photo/photo_connector.dart';
import 'package:photo_anywhere/screens/showcase/showcase_connector.dart';
import 'package:photo_anywhere/screens/setting/settings_connector.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class BottomNavigationBarController extends StatefulWidget {

  BaseAuth auth;
  String loggedInEmail;
  VoidCallback signOutCallback;

  BottomNavigationBarController(
      BaseAuth candidateAuth,
      VoidCallback candidateSignOutCallback) {
    this.auth = candidateAuth;
    this.signOutCallback = candidateSignOutCallback;
  }

  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  final List<Widget> pages = [
    HomeConnector(
      key: PageStorageKey('home'),
    ),
    PhotoConnector(
      key: PageStorageKey('photo'),
    ),
    OrderConnector(
      key: PageStorageKey('order'),
    ),
    ShowcaseConnector(
      key: PageStorageKey('showcase'),
    ),
    UserExceptionDialog<AppState>(
      child: SettingsConnector(
        key: PageStorageKey('settings'),
      ),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  void navigateToScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    onTap: (int index) => setState(() => _selectedIndex = index),
    currentIndex: selectedIndex,
    type: BottomNavigationBarType.fixed,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.photo_library),
        title: Text('Photos'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        title: Text('Orders'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.highlight),
        title: Text('Showcase'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('Settings'),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
      appBar: AppBar(
        title: const Text('Photo Anywhere'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Photo Anywhere',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
//            UserAccountsDrawerHeader(
//              accountEmail: Text('email goes here'),
//            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              subtitle: Text('Find a place to photograph'),
              onTap: () async {
                Navigator.pop(context);
                navigateToScreen(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Photos'),
              subtitle: Text('View photos you have ordered'),
              onTap: () async {
                Navigator.pop(context);
                navigateToScreen(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Orders'),
              subtitle: Text('View your orders'),
              onTap: () async {
                Navigator.pop(context);
                navigateToScreen(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.highlight),
              title: Text('Showcase'),
              subtitle: Text('See other people\'s photos'),
              onTap: () async {
                Navigator.pop(context);
                navigateToScreen(3);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              subtitle: Text('Configure your account'),
              onTap: () async {
                Navigator.pop(context);
                navigateToScreen(4);
              },
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              subtitle: Text('Details about this app'),
              onTap: () async {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              subtitle: Text('Leave or switch accounts'),
              onTap: () async {
                Navigator.pop(context);
                await widget.auth.signOut();
                widget.signOutCallback();
              },
            ),
          ],
        ),
      ),
    );
  }
}
