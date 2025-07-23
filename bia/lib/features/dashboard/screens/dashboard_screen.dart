
import 'package:bia/features/dashboard/providers/dashboard_provider.dart';
import 'package:bia/core/models/movement_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchDashboardData(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Card de Bienvenida
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '¡Bienvenido, Alejandro!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sección de Estadísticas Clave
                const Text(
                  'Estadísticas Clave',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(context, Icons.warning_amber_rounded, 'Bajo Stock', provider.lowStockProducts.length.toString()),
                        _buildStatItem(context, Icons.inventory_2_outlined, 'Total Productos', provider.totalProductCount.toString()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sección de Actividad Reciente
                const Text(
                  'Actividad Reciente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (provider.recentMovements.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: Text('No hay actividad reciente.')),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.recentMovements.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final movement = provider.recentMovements[index];
                      final isEntry = movement.type == MovementType.entry;
                      final productName = provider.getProductNameById(movement.productId);
                      return _buildActivityItem(
                        icon: isEntry ? Icons.arrow_upward_outlined : Icons.arrow_downward_outlined,
                        title: isEntry ? 'Entrada de Producto' : 'Salida de Producto',
                        subtitle: '$productName - ${movement.quantity} unidades',
                        time: _formatTimestamp(movement.date.toDate()),
                        color: isEntry ? Colors.green : Colors.redAccent,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 1) {
      return DateFormat('dd/MM/yy').format(date);
    } else if (difference.inHours >= 1) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inMinutes >= 1) {
      return 'Hace ${difference.inMinutes}m';
    } else {
      return 'Ahora mismo';
    }
  }

  // Widget para construir cada item de estadística
  static Widget _buildStatItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Widget para construir cada item de la lista de actividad
  static Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    Color color = Colors.blue,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
