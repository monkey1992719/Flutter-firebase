import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:photo_anywhere/screens/photo/photo_view_model.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class PhotoScreen extends StatefulWidget {

  final PhotoViewModel viewModel;

  PhotoScreen({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            child: Column(
              children: <Widget>[

              ],
            ),
          ),
        ),
      ],
    );
  }
}
