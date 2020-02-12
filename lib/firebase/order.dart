import 'package:cloud_firestore/cloud_firestore.dart';

class Order
{
  final String address;
  final String instructions;
  final GeoPoint location;
  final DocumentReference reference;

  Order.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['address'] != null),
        assert(map['location'] != null),
        address = map['address'],
        instructions = map['instructions'],
        location = map['location'];

  Order.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Order<$address:$instructions:$location>";
}
