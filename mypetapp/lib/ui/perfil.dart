import 'package:flutter/material.dart';
import 'package:mypetapp/utils/session_manager.dart';
import '../modelos/usuario_modelo.dart';
import '../proveedor/usuario_proveedor.dart';
import 'editar_perfil.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PerfilUsuarioScreenState createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  final UsuarioProvider _usuarioProvider = UsuarioProvider();
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarPerfilUsuario();
  }

  // Método para cargar el perfil de usuario
  Future<void> _cargarPerfilUsuario() async {
    String? userId = await SessionManager.getUserId(); // Obtiene el ID de usuario desde la sesión
    // ignore: avoid_print
    print('User ID desde sesión: $userId');
    Usuario? usuario = await _usuarioProvider.obtenerPerfil(userId!);
    setState(() {
      _usuario = usuario;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: _usuario != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${_usuario!.nombre}', style: const TextStyle(fontSize: 18)),
                  Text('Edad: ${_usuario!.edad}', style: const TextStyle(fontSize: 18)),
                  Text('Sexo: ${_usuario!.sexo}', style: const TextStyle(fontSize: 18)),
                  Text('Especie: ${_usuario!.especie}', style: const TextStyle(fontSize: 18)),
                  Text('Raza: ${_usuario!.raza}', style: const TextStyle(fontSize: 18)),
                  Text('Color: ${_usuario!.color}', style: const TextStyle(fontSize: 18)),
                  Text('Peso: ${_usuario!.peso}', style: const TextStyle(fontSize: 18)),
                  Text('Correo: ${_usuario!.correo}', style: const TextStyle(fontSize: 18)),
                  Text('Usuario: ${_usuario!.usuario}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                    final usuarioActualizado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarPerfilScreen(usuario: _usuario!),
                      ),
                    );

                    // Si se regresó un usuario actualizado, actualiza el perfil en pantalla
                    if (usuarioActualizado != null && usuarioActualizado is Usuario) {
                      setState(() {
                        _usuario = usuarioActualizado;
                      });
                    }
                  },
                  child: const Text('Editar Perfil'),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()), // Muestra un indicador de carga
    );
  }
}
