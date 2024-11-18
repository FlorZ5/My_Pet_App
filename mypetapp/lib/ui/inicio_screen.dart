import 'package:flutter/material.dart';
import '../utils/session_manager.dart';
import 'login_screen.dart';
import 'perfil.dart';
import 'agregar_cita.dart';
import 'agregar_vacuna.dart';
import 'agregar_historial.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Bienvenido a la aplicación!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilUsuarioScreen()),
                );
              },
              child: const Text('Ver Perfil'),
            ), 
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormularioCitaScreen()),
                );
              },
              child: const Text('Agregar Cita'), // Botón para agregar citas
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormularioVacunaScreen()),
                );
              },
              child: const Text('Agregar Vacuna'), // Botón para agregar vacunas
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormularioHistorialScreen()),
                );
              },
              child: const Text('Agregar historial'), // Botón para agregar historial
            ),
          ],
        ),
      ),
    );
  }
}
