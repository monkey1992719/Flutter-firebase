import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:photo_anywhere/firebase/order.dart';
import 'package:photo_anywhere/screens/order/order_view_model.dart';

class OrderScreen extends StatefulWidget {

  final OrderViewModel viewModel;

  OrderScreen({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double abovePadding = MediaQuery.of(context).padding.top;
    double screenHeight = size.height;
    double remainingHeight = screenHeight - abovePadding;
    double usableHeight = remainingHeight * 0.8;
    return Stack(
      children: <Widget>[
        Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            child: Column(
              children: <Widget>[
              Container(
                height: usableHeight,
                  child: _buildBody(context),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('orders')
          .where("user_id", isEqualTo: widget.viewModel.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 12.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final order = Order.fromSnapshot(data);

    return Padding(
      key: ValueKey(order.reference.documentID),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: ListTile(
        title: Text(order.reference.documentID),
        subtitle: Text(order.address),
        trailing: Text('>'),
      ),
    );
  }
}
