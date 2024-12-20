import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedor/historial_proveedor.dart';
import 'editar_historial.dart';
import 'agregar_cita.dart';
import 'agregar_vacuna.dart';
import 'clinicas.dart';
import 'conocenos.dart';
import 'contactos.dart';
import 'inicio_screen.dart';
import 'perfil.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historialProveedor = Provider.of<HistorialProveedor>(context, listen: false);

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
                   const Flexible(
                      child: Text(
                        'Historial\nmédico',
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
                            case 'Vacunas':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FormularioVacunaScreen()),
                              );
                              break;
                            case 'Perfil':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PerfilUsuarioScreen()), 
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
                            value: 'Perfil',
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/perfil.png', // Ruta ícono
                                  width: 25, // Tamaño del ícono
                                  height: 25,
                                ),
                                const SizedBox(width: 10), // Espacio entre el ícono y el texto
                                const Text(
                                  'Perfil',
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
                      margin: const EdgeInsets.only(top: 50.0,),
                      child: const Text(
                        'Historial de enfermedades',
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
        FutureBuilder(
          future: historialProveedor.cargarHistorialUsuario(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text(
                'Ocurrió un error al cargar las enfermedades',
                style: TextStyle(color: Colors.red),
              );
            } else {
              return Consumer<HistorialProveedor>(
                builder: (context, historialData, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView.builder(
                      itemCount: historialData.historial.length,
                      itemBuilder: (context, index) {
                        final historial = historialData.historial[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Color(0xFF00B2FF), width: 2.0),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
                            child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Enfermedad: ${historial.enfermedad}',
                                  style: const TextStyle(fontSize: 18.5,),
                                  textAlign: TextAlign.center
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tratamiento: ${historial.tratamiento}',
                                  style: const TextStyle(fontSize: 18.5),
                                  textAlign: TextAlign.center
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Estado del tratamiento: ${historial.estadoTratamiento}',
                                  style: const TextStyle(fontSize: 18.5),
                                  textAlign: TextAlign.center
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                     GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditarHistorialScreen(historial: historial),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.edit, color: Color.fromARGB(255, 112, 112, 112), size: 23), // Tamaño reducido
                                    ),
                                    const SizedBox(width: 10),
                                     GestureDetector(
                                      onTap: () async {
                                        if (historial.idHistorial != null) {
                                          await historialData.eliminarHistorial(historial.idHistorial!);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("El ID del historial no es válido."),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Icon(Icons.delete, color: Color.fromARGB(255, 112, 112, 112), size: 23), // Tamaño reducido
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ]
                          )
                          )
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
     ]
    ),
    ),
    ),
    ),
    );
  }
}