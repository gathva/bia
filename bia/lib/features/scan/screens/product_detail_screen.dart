import 'package:bia/core/models/movement_model.dart';
import 'package:bia/core/models/product_model.dart';
import 'package:bia/core/services/firestore_service.dart';
import 'package:bia/features/dashboard/providers/dashboard_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isProcessing = false;

  Future<void> _showMovementDialog(MovementType type) async {
    final quantityController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(type == MovementType.entry ? 'Registrar Entrada' : 'Registrar Salida'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese una cantidad';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return 'Ingrese un número válido';
                }
                if (type == MovementType.exit && quantity > widget.product.stockActual) {
                  return 'No hay suficiente stock';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _registerMovement(type, int.parse(quantityController.text));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerMovement(MovementType type, int quantity) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final newMovement = Movement(
        id: '', // Firestore generará el ID
        productId: widget.product.id,
        type: type,
        quantity: quantity,
        date: Timestamp.now(),
        responsibleUid: 'user_id_placeholder', // TODO: Reemplazar con el ID del usuario autenticado
      );

      await _firestoreService.addMovementAndUpdateStock(newMovement);

      if (mounted) {
        // Notificar al DashboardProvider para que recargue los datos
        Provider.of<DashboardProvider>(context, listen: false).reloadData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movimiento registrado con éxito')),
        );
        
        Navigator.of(context).pop(); // Volver a la pantalla anterior
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Código: ${widget.product.barcode}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.business_outlined, 'Marca', widget.product.brand.isNotEmpty ? widget.product.brand : 'N/A'),
                        const Divider(),
                        _buildInfoRow(Icons.description, 'Descripción', widget.product.description.isNotEmpty ? widget.product.description : 'N/A'),
                        const Divider(),
                        _buildInfoRow(Icons.location_on, 'Ubicación', widget.product.location.isNotEmpty ? widget.product.location : 'N/A'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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
                              widget.product.stockActual.toString(),
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showMovementDialog(MovementType.entry),
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
                        onPressed: () => _showMovementDialog(MovementType.exit),
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
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
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