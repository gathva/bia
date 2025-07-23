import 'package:bia/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              // El AuthWrapper se encargará de redirigir a LoginScreen
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('¡Bienvenido!'),
      ),
    );
  }
}
