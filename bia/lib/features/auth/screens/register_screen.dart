import 'package:bia/features/auth/services/auth_service.dart';
import 'package:bia/features/auth/widgets/auth_form_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = await _authService.registerWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (user != null && mounted) {
      // Navegar a la pantalla principal o de login después del registro exitoso
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BIA - Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthFormField(
              controller: _emailController,
              labelText: 'Correo Electrónico',
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _passwordController,
              labelText: 'Contraseña',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _confirmPasswordController,
              labelText: 'Confirmar Contraseña',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Registrarse'),
                  ),
          ],
        ),
      ),
    );
  }
}
