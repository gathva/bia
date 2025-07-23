import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, editor, viewer }

class AppUser {
  final String uid;
  final String email;
  final UserRole role;
  final List<String> warehouseIds; // IDs de las bodegas a las que tiene acceso

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.warehouseIds,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == data['role'],
        orElse: () => UserRole.viewer,
      ),
      warehouseIds: List<String>.from(data['warehouseIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'role': role.toString(),
      'warehouseIds': warehouseIds,
    };
  }
}
