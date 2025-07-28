
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
    try {
      await _db.collection('products').doc(product.id).update(product.toMap());
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  // Registrar un nuevo movimiento (entrada/salida)
  Future<void> addMovement(Movement movement) async {
    try {
      await _db.collection('movements').add(movement.toMap());
    } catch (e) {
      print('Error adding movement: $e');
      rethrow;
    }
  }

  // Registrar un movimiento y actualizar el stock del producto en una transacción
  Future<void> addMovementAndUpdateStock(Movement movement) async {
    final productRef = _db.collection('products').doc(movement.productId);
    final movementRef = _db.collection('movements').doc(); // Nuevo documento para el movimiento

    try {
      await _db.runTransaction((transaction) async {
        // 1. Obtener el documento del producto
        final productSnapshot = await transaction.get(productRef);

        if (!productSnapshot.exists) {
          throw Exception("El producto no existe!");
        }

        // 2. Calcular el nuevo stock
        final currentStock = productSnapshot.data()!['stock_actual'] as int;
        final newStock = movement.type == MovementType.entry
            ? currentStock + movement.quantity
            : currentStock - movement.quantity;

        if (newStock < 0) {
          throw Exception('No hay suficiente stock para esta salida.');
        }

        // 3. Actualizar el stock del producto y la fecha de actualización
        transaction.update(productRef, {
          'stock_actual': newStock,
          'updatedAt': FieldValue.serverTimestamp(), // Usar la hora del servidor
        });

        // 4. Registrar el nuevo movimiento
        transaction.set(movementRef, movement.toMap());
      });
    } catch (e) {
      print('Error en la transacción de movimiento: $e');
      rethrow;
    }
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

  // Buscar un producto por su nombre
  Future<List<Product>> searchProductByName(String name) async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThanOrEqualTo: name + '\uf8ff')
          .get();
      final products = snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
      return products;
    } catch (e) {
      print('Error searching product by name: $e');
      return [];
    }
  }

  // Obtener el stock de un producto específico
  Future<int?> getProductStock(String productName) async {
    try {
      final products = await searchProductByName(productName);
      if (products.isNotEmpty) {
        return products.first.stockActual;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product stock: $e');
      return null;
    }
  }
}
