
import 'package:flutter/material.dart';

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
      body: ListView(
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
                  _buildStatItem(context, Icons.warning_amber_rounded, 'Bajo Stock', '5'),
                  _buildStatItem(context, Icons.inventory_2_outlined, 'Total Productos', '120'),
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
          _buildActivityItem(
            icon: Icons.add_box_outlined,
            title: 'Nuevo Producto Registrado',
            subtitle: 'Tornillos de 1/4" - 50 unidades',
            time: 'Hace 5 min',
          ),
          const Divider(),
          _buildActivityItem(
            icon: Icons.arrow_downward_outlined,
            title: 'Salida de Producto',
            subtitle: 'Martillo de bola - 2 unidades',
            time: 'Hace 1 hora',
            color: Colors.redAccent,
          ),
          const Divider(),
          _buildActivityItem(
            icon: Icons.arrow_upward_outlined,
            title: 'Entrada de Producto',
            subtitle: 'Cinta aislante - 10 unidades',
            time: 'Hace 3 horas',
            color: Colors.green,
          ),
        ],
      ),
    );
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
