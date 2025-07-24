
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String barcode;
  final String description;
  final int stockActual;
  final String location;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.description,
    required this.stockActual,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  Product copyWith({
    String? id,
    String? name,
    String? barcode,
    String? description,
    int? stockActual,
    String? location,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      stockActual: stockActual ?? this.stockActual,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'description': description,
      'stock_actual': stockActual,
      'location': location,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId,
      name: map['name'] ?? '',
      barcode: map['barcode'] ?? '',
      description: map['description'] ?? '',
      stockActual: map['stock_actual']?.toInt() ?? 0,
      location: map['location'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source, String documentId) => Product.fromMap(json.decode(source), documentId);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, barcode: $barcode, description: $description, stockActual: $stockActual, location: $location, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Product &&
      other.id == id &&
      other.name == name &&
      other.barcode == barcode &&
      other.description == description &&
      other.stockActual == stockActual &&
      other.location == location &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      barcode.hashCode ^
      description.hashCode ^
      stockActual.hashCode ^
      location.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}

