import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:photo_anywhere/screens/setting/settings_view_model.dart';

class SettingsScreen extends StatefulWidget {

  final SettingsViewModel viewModel;

  SettingsScreen({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  TextEditingController addressController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.viewModel.address);
    firstNameController = TextEditingController(text: widget.viewModel.firstName);
    lastNameController = TextEditingController(text: widget.viewModel.lastName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: FirebaseAuth.instance.currentUser().then((user) => user.email),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                default:
                  return buildStack(context, snapshot.data);
              }
            }));
  }

  Stack buildStack(BuildContext context, String userEmail) {
    return Stack(
      children: <Widget>[
        Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Account',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email Address',
                    ),
                    enabled: false,
                    initialValue: userEmail,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          height: 40.0,
                          child: RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                            color: Colors.blue,
                            child: const Text(
                              'Change Password',
                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Text(
                      'Settings',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'First Name',
                    ),
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Last Name',
                    ),
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.location_on),
                      labelText: 'Default Address',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text('Lat: '
                          + widget.viewModel.location.latitude.toString()
                          + '    Lng: '
                          + widget.viewModel.location.longitude.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 34.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          height: 40.0,
                          child: RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                            color: Colors.blue,
                            child: const Text(
                              'Save Settings',
                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                            onPressed: () => widget.viewModel.onSaveSettings(
                                new SettingsViewModel().initialize(
                                  widget.viewModel.auth,
                                  addressController.text,
                                  firstNameController.text,
                                  lastNameController.text,
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
