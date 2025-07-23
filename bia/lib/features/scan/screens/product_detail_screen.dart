
import 'package:bia/core/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del Producto
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // Código de Barras
            Text(
              'Código: ${product.barcode}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Tarjeta de Información General
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.description, 'Descripción', product.description.isNotEmpty ? product.description : 'N/A'),
                    const Divider(),
                    _buildInfoRow(Icons.location_on, 'Ubicación', product.location.isNotEmpty ? product.location : 'N/A'),
                    const Divider(),
                    _buildInfoRow(Icons.calendar_today, 'Creado', '${product.createdAt.toDate().toLocal().toString().split(' ')[0]}'),
                    const Divider(),
                    _buildInfoRow(Icons.update, 'Última Actualización', '${product.updatedAt.toDate().toLocal().toString().split(' ')[0]}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tarjeta de Stock Actual
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock Actual',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          product.stockActual.toString(),
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                    const Icon(Icons.inventory_2_outlined, size: 60, color: Colors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botones de Gestión de Stock
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar diálogo para registrar entrada
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registrar Entrada')),
                      );
                    },
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text('Entrada'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar diálogo para registrar salida
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registrar Salida')),
                      );
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    label: const Text('Salida'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
