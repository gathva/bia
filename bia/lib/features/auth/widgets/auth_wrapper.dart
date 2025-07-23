import 'package:bia/features/app/screens/app_shell.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Por ahora, siempre mostramos el AppShell.
    // En el futuro, aquí irá la lógica para decidir si mostrar
    // la pantalla de login o la app principal.
    return const AppShell();
  }
}