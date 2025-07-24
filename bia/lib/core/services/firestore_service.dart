
import 'package:bia/core/models/movement_model.dart';
import 'package:bia/core/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener todos los productos
  Future<List<Product>> getProducts() async {
    try {
      final snapshot = await _db.collection('products').get();
      final products = snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
      return products;
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  // Obtener productos con bajo stock (ej: menos de 10 unidades)
  Future<List<Product>> getProductsWithLowStock({int threshold = 10}) async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('stock_actual', isLessThan: threshold)
          .get();
      final products = snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
      return products;
    } catch (e) {
      print('Error getting products with low stock: $e');
      return [];
    }
  }

  // Obtener los movimientos más recientes (ej: los últimos 10)
  Future<List<Movement>> getRecentMovements({int limit = 10}) async {
    try {
      final snapshot = await _db
          .collection('movements')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      final movements = snapshot.docs
          .map((doc) => Movement.fromMap(doc.data(), doc.id))
          .toList();
      return movements;
    } catch (e) {
      print('Error getting recent movements: $e');
      return [];
    }
  }

  // Añadir un nuevo producto
  Future<void> addProduct(Product product) async {
    try {
      await _db.collection('products').add(product.toMap());
    } catch (e) {
      print('Error adding product: $e');
      // Opcional: relanzar el error para manejarlo en la UI
      rethrow;
    }
  }

  // Actualizar un producto existente
  Future<void> updateProduct(Product product) async {
    // TODO: Implementar la lógica para actualizar un producto
  }

  // Registrar un nuevo movimiento (entrada/salida)
  Future<void> addMovement(Movement movement) async {
    // TODO: Implementar la lógica para registrar un movimiento
  }

  // Buscar un producto por su código de barras
  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return Product.fromMap(doc.data(), doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product by barcode: $e');
      return null;
    }
  }
}
