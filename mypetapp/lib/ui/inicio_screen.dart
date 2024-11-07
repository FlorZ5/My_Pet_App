import 'package:flutter/material.dart';
import '../utils/session_manager.dart';
import 'login_screen.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    await SessionManager.clearSession();
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('¡Bienvenido a la aplicación!'),
      ),
    );
  }
}
