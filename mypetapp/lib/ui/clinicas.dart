import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaClinicas extends StatelessWidget {
  const PaginaClinicas({super.key});

  void _llamar(String numero) async {
    final Uri url = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('No se pudo abrir el marcador para $numero');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinicas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const Text(
            "A continuación, te brindamos información de clinicas veterinarias dentro del estado de Aguascalientes.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          _crearTarjetaContacto(
            'Veterinaria Medical zoo',
            '4493872617',
            'Beethoven 517, Col del Trabajo, 20180, Aguasclientes, Ags.',
          ),
          _crearTarjetaContacto(
            'Clínica Veterinaria El Dorado',
            '4499133662',
            'Av. Las Américas 1701-Interior 59, Valle Dorado, 20235 Aguascalientes, Ags.',
          ),
          _crearTarjetaContacto(
            'Animal Care Hospital Veterinario 24/7 en Aguascalientes',
            '4499293674',
            'Av. Universidad 1605, Lomas del Campestre I, 20120 Aguascalientes, Ags.',
          ),
          _crearTarjetaContacto(
            'Hospital Veterianrio CANEM',
            '4499148043',
            'Av. de la Convención de 1914 Nte. 1506, Circunvalación Nte., 20020 Aguascalientes, Ags.',
          ),
        ],
      ),
    );
  }

  Widget _crearTarjetaContacto(
      String nombre, String telefono, String direccion) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          nombre,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teléfono: $telefono',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
            Text(
              'Dirección: $direccion',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
        trailing: const Icon(Icons.phone, color: Colors.green),
        onTap: () => _llamar(telefono),
      ),
    );
  }
}

