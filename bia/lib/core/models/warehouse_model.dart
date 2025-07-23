import 'package:cloud_firestore/cloud_firestore.dart';

class Warehouse {
  final String id;
  final String name;
  final String location;

  Warehouse({
    required this.id,
    required this.name,
    required this.location,
  });

  factory Warehouse.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Warehouse(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
    };
  }
}
