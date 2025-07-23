
import 'package:bia/core/models/movement_model.dart';
import 'package:bia/core/models/product_model.dart';
import 'package:bia/core/services/firestore_service.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Product> _lowStockProducts = [];
  List<Movement> _recentMovements = [];
  List<Product> _allProducts = []; // Para tener todos los productos
  bool _isLoading = false;

  List<Product> get lowStockProducts => _lowStockProducts;
  List<Movement> get recentMovements => _recentMovements;
  int get totalProductCount => _allProducts.length; // Getter para el total
  bool get isLoading => _isLoading;

  DashboardProvider() {
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    // Obtener todos los datos en paralelo
    final results = await Future.wait([
      _firestoreService.getProductsWithLowStock(),
      _firestoreService.getRecentMovements(),
      _firestoreService.getProducts(),
    ]);

    _lowStockProducts = results[0] as List<Product>;
    _recentMovements = results[1] as List<Movement>;
    _allProducts = results[2] as List<Product>;

    _isLoading = false;
    notifyListeners();
  }

  // Método para obtener el nombre de un producto por su ID
  String getProductNameById(String productId) {
    try {
      return _allProducts.firstWhere((p) => p.id == productId).name;
    } catch (e) {
      return 'Producto no encontrado';
    }
  }
}
