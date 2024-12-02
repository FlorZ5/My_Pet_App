import 'package:flutter/material.dart';
import 'package:mypetapp/utils/session_manager.dart';
import '../modelos/usuario_modelo.dart';
import '../proveedor/usuario_proveedor.dart';
import 'editar_perfil.dart';
import 'agregar_cita.dart';
import 'agregar_historial.dart';
import 'agregar_vacuna.dart';
import 'clinicas.dart';
import 'conocenos.dart';
import 'contactos.dart';
import 'inicio_screen.dart';

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
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: _usuario != null
          ? SingleChildScrollView(
        child: Center( // Centra el contenido horizontalmente
        child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Container(
                margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye los elementos
                  crossAxisAlignment: CrossAxisAlignment.center, // Alinea verticalmente
                  children: [
                    // Texto alineado a la izquierda
                   const Flexible(
                      child: Text(
                        'Perfil',
                        style: TextStyle(
                          color: Color(0xFF036E9C),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true, // Permite que el texto se divida en varias líneas
                        maxLines: 2, // Limita el texto a dos líneas
                        overflow: TextOverflow.ellipsis, // Muestra puntos suspensivos si el texto es muy largo
                      ),
                    ),
                    // Imagen alineada a la derecha
                    Image.asset(
                      'lib/assets/icono.png', // Ruta de la imagen 
                      width: 60, // Ajusta el tamaño de la imagen
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    // Menú desplegable en lugar del botón de cerrar sesión
                    Material(
                      color: const Color(0xFF036E9C), // Color de fondo
                      shape: const CircleBorder(), // Botón circular
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 27.5, // Tamaño del ícono
                        ),
                        color: const Color(0xFF036E9C), // Fondo del menú desplegable
                        onSelected: (String value) {
                          switch (value) {
                            case 'Inicio':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PaginaInicio()), // Pantalla Home
                              );
                              break;
                            case 'Citas':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FormularioCitaScreen()), // Pantalla Home
                              );
                              break;
                            case 'Historial médico':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FormularioHistorialScreen()),
                              );
                              break;
                            case 'Vacunas':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FormularioVacunaScreen()), 
                              );
                              break;
                              case 'Contactos de emergencia':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PaginaContactos()),
                              );
                              break;
                              case 'Conócenos':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PaginaConocenos()), 
                              );
                              break;
                              case 'Clínicas veterinarias':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PaginaClinicas()), 
                              );
                              break;
                            default:
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'Inicio',
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/inicio.png', // Ruta  ícono
                                  width: 25, // Tamaño del ícono
                                  height: 25,
                                ),
                                const SizedBox(width: 10), // Espacio entre el ícono y el texto
                                const Text(
                                  'Inicio',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Citas',
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/citas.png', // Ruta ícono
                                  width: 25, // Tamaño del ícono
                                  height: 25,
                                ),
                                const SizedBox(width: 10), // Espacio entre el ícono y el texto
                                const Text(
                                  'Citas',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Historial médico',
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/historial.png', // Ruta ícono
                                  width: 25, // Tamaño del ícono
                                  height: 25,
                                ),
                                const SizedBox(width: 10), // Espacio entre el ícono y el texto
                                const Text(
                                  'Historial médico',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Vacunas',
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/vacunas.png', // Ruta ícono
                                  width: 25, // Tamaño del ícono
                                  height: 25,
                                ),
                                const SizedBox(width: 10), // Espacio entre el ícono y el texto
                                const Text(
                                  'Vacunas',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),  
                          PopupMenuItem<String>(
                            value: 'Contactos de emergencia',
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/contactos.png', // Ruta ícono
                                  width: 25, // Tamaño del ícono
                                  height: 25,
                                ),
                                const SizedBox(width: 10), // Espacio entre el ícono y el texto
                                const Text(
                                  'Contactos de emergencia',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ), 
                          PopupMenuItem<String>(
                            value: 'Conócenos',
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/conocenos.png', // Ruta ícono
                                  width: 25, // Tamaño del ícono
                                  height: 25,
                                ),
                                const SizedBox(width: 10), // Espacio entre el ícono y el texto
                                const Text(
                                  'Conócenos',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ), 
                          PopupMenuItem<String>(
                            value: 'Clínicas veterinarias',
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/clinicas.png', // Ruta ícono
                                  width: 25, // Tamaño del ícono
                                  height: 25,
                                ),
                                const SizedBox(width: 10), // Espacio entre el ícono y el texto
                                const Text(
                                  'Clínicas veterinarias',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),                     
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Contenido principal
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50.0, bottom: 30.0),
                      child: const Text(
                        'Ver perfil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ),  
              ),
                  Container(                    
                    margin: const EdgeInsets.all(16.0), // Espaciado externo
                    padding: const EdgeInsets.all(16.0), // Espaciado interno
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                      border: Border.all(color: const Color(0xFF00B2FF), width: 2), // Borde azul
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12, // Sombra sutil
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Centrar el texto
                      children: [
                        Text('Nombre: ${_usuario?.nombre}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('Edad: ${_usuario?.edad}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('Sexo: ${_usuario?.sexo}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('Especie: ${_usuario?.especie}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('Raza: ${_usuario?.raza}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('Color: ${_usuario?.color}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('Peso: ${_usuario?.peso}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('Correo: ${_usuario?.correo}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('Usuario: ${_usuario?.usuario}', style: const TextStyle(fontSize: 18.5), textAlign: TextAlign.center),
                      ],
                    ),
                  ),               
                   Container(
                    margin: const EdgeInsets.only(top: 40.0, bottom: 40),
                    child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: const Color(0xFF00B2FF),
                      minimumSize: const Size(150, 50)
                  ),
                  child: const Text('Editar perfil',  style: TextStyle(fontSize: 22.0),),
                  ),
                  ),
                ],
              ),
            )
        )
        )
          : const Center(child: CircularProgressIndicator()), // Muestra un indicador de carga
    );
  }
}
