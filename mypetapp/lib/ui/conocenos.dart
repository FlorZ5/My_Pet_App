import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaConocenos extends StatelessWidget {
  const PaginaConocenos({super.key});

  void _llamar(String numero) async {
    final Uri url = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('No se pudo abrir el marcador para $numero');
    }
  }

  void _abrirEnlace(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('No se pudo abrir el enlace $url');
    }
  }

  void _abrirWhatsApp(String numero) async {
    final Uri url = Uri.parse('https://wa.me/$numero');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('No se pudo abrir WhatsApp para el número $numero');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conócenos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const Text(
            "Pet Life es una empresa dedicada a mejorar los cuidados de las mascotas, ayudando a que tengan una mejor calidad de vida y una salud integral.\n"
            "En Pet Life tenemos más de 10 años de experiencia en el cuidado de mascotas y manejo integral de su salud.\n"
            "En nuestra empresa nos dedicamos a brindar servicios veterinarios, de guardería y estética para mascotas.\n"
            "Contando con buenas recomendaciones y opiniones de nuestros clientes.\n"
            "En esta aplicación hemos combinado nuestra experiencia con las necesidades para el cuidado de mascotas, brindando un espacio en donde podrás llevar el control de tu mascota, así como encontrar números de emergencia y clínicas veterinarias cerca de ti.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          const Text(
            "Nuestros contactos",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _crearTarjetaContacto('Número telefónico', '4499874561', false),
          _crearTarjetaContacto('WhatsApp', '4494561237', true),
          const SizedBox(height: 30),
          const Text(
            "Síguenos en nuestras redes sociales:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _crearBotonRedSocial(
                'Facebook',
                FontAwesomeIcons.facebook,
                Colors.blue,
                'https://www.facebook.com/petlife',
              ),
              _crearBotonRedSocial(
                'Instagram',
                FontAwesomeIcons.instagram,
                Colors.pink,
                'https://www.instagram.com/petlife',
              ),
              _crearBotonRedSocial(
                'X (Twitter)',
                FontAwesomeIcons.xTwitter, // Ícono de X
                Colors.black,
                'https://twitter.com/petlife',
              ),
              _crearBotonRedSocial(
                'TikTok',
                FontAwesomeIcons.tiktok,
                Colors.black,
                'https://www.tiktok.com/@petlife',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _crearTarjetaContacto(String nombre, String telefono, bool esWhatsApp) {
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
        trailing: Icon(
          esWhatsApp ? FontAwesomeIcons.whatsapp : Icons.phone,
          color: esWhatsApp ? Colors.green : Colors.black,
        ),
        onTap: () => esWhatsApp ? _abrirWhatsApp(telefono) : _llamar(telefono),
      ),
    );
  }

  Widget _crearBotonRedSocial(
      String nombre, IconData icono, Color color, String url) {
    return IconButton(
      icon: FaIcon(icono, color: color, size: 30),
      onPressed: () => _abrirEnlace(url),
      tooltip: nombre,
    );
  }
}