import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:photo_anywhere/screens/showcase/showcase_view_model.dart';
import 'package:photo_anywhere/screens/showcase/widgets/showcase_carousel.dart';

class ShowcaseScreen extends StatefulWidget {

  final ShowcaseViewModel viewModel;

  ShowcaseScreen({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _ShowcaseScreenState createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {

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
                ShowcaseCarousel(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
