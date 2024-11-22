import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaContactos extends StatelessWidget {
  const PaginaContactos({super.key});

  void _llamar(String numero) async {
    final Uri url = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Si no puede abrir el marcador, muestra un mensaje de error
      debugPrint('No se pudo abrir el marcador para $numero');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
           const Text(
              "A continuación te proporcionamos números teléfonicos a los que puedes llamar en caso de emergencia.\n"
              "Al marcarlos, un profesional te brindará asistencia veterinaria vía telefónica.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
          _crearTarjetaContacto('Atención veterinaria en general', '4491234567'),
          _crearTarjetaContacto('Atención veterinaria para aves', '4491234589'),
          _crearTarjetaContacto('Atención veterinaria canina', '4651234567'),
          _crearTarjetaContacto('Atención veterinaria felina', '4931234567'),
          _crearTarjetaContacto('Atención veterinaria para especies exoticas', '4331234567'),
          _crearTarjetaContacto('Atención veterinaria para especies pequeñas', '4771234567'),
        ],
      ),
    );
  }

  Widget _crearTarjetaContacto(String nombre, String telefono) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          nombre,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          telefono,
          style: const TextStyle(fontSize: 16, color: Colors.blue),
        ),
        trailing: const Icon(Icons.phone, color: Colors.green),
        onTap: () => _llamar(telefono),
      ),
    );
  }
}
