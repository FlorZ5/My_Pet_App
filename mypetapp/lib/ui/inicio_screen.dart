import 'package:flutter/material.dart';
import '../utils/session_manager.dart';
import 'login_screen.dart';
import 'perfil.dart';
import 'agregar_cita.dart';
import 'agregar_vacuna.dart';
import 'agregar_historial.dart';
import 'contactos.dart';
import 'conocenos.dart';
import 'clinicas.dart';

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
    backgroundColor: Colors.black,
    resizeToAvoidBottomInset: true,
    body: SingleChildScrollView(
      child: Center(
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
                    const Text(
                      'Inicio',
                      style: TextStyle(
                        color: Color(0xFF036E9C),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Imagen alineada a la derecha
                    Image.asset(
                      'lib/assets/icono.png', // Ruta de la imagen 
                      width: 60, // Ajusta el tamaño de la imagen
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    // Botón de Cerrar Sesión
                    Material(
                      color: const Color(0xFF036E9C), // Color de fondo
                      shape: const CircleBorder(), // Botón circular
                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        iconSize: 27.5, // Tamaño del ícono
                        color: Colors.white, // Color del ícono
                        onPressed: () => _cerrarSesion(context),
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
                      margin: const EdgeInsets.only(top: 30.0,),
                      child: const Text(
                        '¡Bienvenido!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 20),
                      child: const Text(
                        'My Pet App',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ]
                ),  
              ),
              // Botones de navegación
              // Botones con icono y texto
              for (var boton in [
              ['FormularioCitaScreen', 'lib/assets/citas.png', 'Citas'],
              ['FormularioHistorialScreen', 'lib/assets/historial.png', 'Historial médico'],
              ['FormularioVacunaScreen', 'lib/assets/vacunas.png', 'Vacunas'],
              ['PerfilUsuarioScreen', 'lib/assets/perfil.png', 'Perfil'],
              ['PaginaContactos', 'lib/assets/contactos.png', 'Contactos de emergencia'],
              ['PaginaConocenos', 'lib/assets/conocenos.png', 'Conócenos'],
              ['PaginaClinicas', 'lib/assets/clinicas.png', 'Clínicas veterinarias'],
            ])
              Container(
                margin: const EdgeInsets.only(bottom: 20.0, top: 20),
                child: SizedBox(
                  width: 200, // Botón ocupa todo el ancho disponible
                  height: 70, // Alto fijo
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          switch (boton[0]) {
                            case 'PerfilUsuarioScreen':
                              return const PerfilUsuarioScreen();
                            case 'FormularioCitaScreen':
                              return const FormularioCitaScreen();
                            case 'FormularioVacunaScreen':
                              return const FormularioVacunaScreen();
                            case 'FormularioHistorialScreen':
                              return const FormularioHistorialScreen();
                            case 'PaginaContactos':
                              return const PaginaContactos();
                            case 'PaginaConocenos':
                              return const PaginaConocenos();
                            case 'PaginaClinicas':
                              return const PaginaClinicas();
                            default:
                              return const Scaffold(); // Fallback
                          }
                        }),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0084BC), // Color de fondo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero, // Elimina el padding interno
                    ),
                    child: Row(
                      children: [
                        // Icono alineado a la izquierda
                        Container(
                          width: 70,
                          height: 70,
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color(0xFFC5C6FF), // Fondo del icono
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Image.asset(
                            boton[1], // Ruta de la imagen
                            width: 75, // Tamaño del ícono
                            height: 75,
                            fit: BoxFit.contain, // Ajusta el icono dentro del espacio disponible
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              boton[2], // Texto del botón
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, //Texto centrado
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}