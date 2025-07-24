
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum MovementType { entry, exit }

class Movement {
  final String id;
  final String productId;
  final MovementType type;
  final int quantity;
  final Timestamp date;
  final String responsibleUid;

  Movement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.date,
    required this.responsibleUid,
  });

  Movement copyWith({
    String? id,
    String? productId,
    MovementType? type,
    int? quantity,
    Timestamp? date,
    String? responsibleUid,
  }) {
    return Movement(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      responsibleUid: responsibleUid ?? this.responsibleUid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'type': type.toString(), // Convert enum to string
      'quantity': quantity,
      'date': date,
      'responsibleUid': responsibleUid,
    };
  }

  factory Movement.fromMap(Map<String, dynamic> map, String documentId) {
    return Movement(
      id: documentId,
      productId: map['productId'] ?? '',
      type: MovementType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => MovementType.entry, // Default value
      ),
      quantity: map['quantity']?.toInt() ?? 0,
      date: map['date'] ?? Timestamp.now(),
      responsibleUid: map['responsibleUid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Movement.fromJson(String source) => Movement.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Movement(id: $id, productId: $productId, type: $type, quantity: $quantity, date: $date, responsibleUid: $responsibleUid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Movement &&
      other.id == id &&
      other.productId == productId &&
      other.type == type &&
      other.quantity == quantity &&
      other.date == date &&
      other.responsibleUid == responsibleUid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      productId.hashCode ^
      type.hashCode ^
      quantity.hashCode ^
      date.hashCode ^
      responsibleUid.hashCode;
  }
}

