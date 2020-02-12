import 'package:cloud_firestore/cloud_firestore.dart';

class ShowcaseItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final GeoPoint location;
  final DocumentReference reference;

  ShowcaseItem.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['description'] != null),
        assert(map['image_url'] != null),
        assert(map['location'] != null),
        id = reference.documentID,
        name = map['name'],
        description = map['description'],
        imageUrl = map['image_url'],
        location = map['location'];

  ShowcaseItem.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "ShowcaseItem<$id:$id, $name:$name, $description:$description, $imageUrl:$imageUrl, $location:$location>";
}
