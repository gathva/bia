import 'package:bia/core/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductListViewScreen extends StatelessWidget {
  final String title;
  final List<Product> products;

  const ProductListViewScreen({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text('No hay productos para mostrar.'),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('Marca: ${product.brand}\nStock: ${product.stockActual}\nCódigo: ${product.barcode}'),
                    isThreeLine: true,
                    // TODO: Implementar navegación a detalles del producto si se desea
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ProductDetailScreen(product: product),
                      //   ),
                      // );
                    },
                  ),
                );
              },
            ),
    );
  }
}
