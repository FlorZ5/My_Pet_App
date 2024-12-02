import 'package:flutter/material.dart';
import 'package:mypetapp/modelos/historial_modelo.dart';
import 'package:mypetapp/proveedor/historial_proveedor.dart';
import 'package:provider/provider.dart';
import '../utils/session_manager.dart';
import 'agregar_cita.dart';
import 'agregar_vacuna.dart';
import 'clinicas.dart';
import 'conocenos.dart';
import 'contactos.dart';
import 'perfil.dart';
import 'inicio_screen.dart';

class EditarHistorialScreen extends StatefulWidget {
  final Historial historial;

  const EditarHistorialScreen({super.key, required this.historial});

  @override
  // ignore: library_private_types_in_public_api
  _EditarHistorialScreenState createState() => _EditarHistorialScreenState();
}

class _EditarHistorialScreenState extends State<EditarHistorialScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _enfermedadController;  
  late TextEditingController _tratamientoController;
  final estadoNotifier = ValueNotifier<String?>(null);
  bool _alertaMostrando = false;

  @override
  void initState() {
    super.initState();
    _enfermedadController = TextEditingController(text: widget.historial.enfermedad);
    _tratamientoController = TextEditingController(text: widget.historial.tratamiento);
    estadoNotifier.value = widget.historial.estadoTratamiento;
  }

  @override
  void dispose() {
    _enfermedadController.dispose();
    _tratamientoController.dispose();
     estadoNotifier.dispose();
    super.dispose();
  }

void _mostrarAlerta(String mensaje) {
    if (!_alertaMostrando) {
      _alertaMostrando = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error de Validación"),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _alertaMostrando = false;
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void _actualizarHistorial() async {
    if (_formKey.currentState!.validate()) {
      final idUsuarioString = await SessionManager.getUserId();
      if (idUsuarioString != null) {
        final idUsuario = int.tryParse(idUsuarioString);
      if (idUsuario != null) {
        final historialActualizado = Historial(
          idHistorial: widget.historial.idHistorial,
          enfermedad: _enfermedadController.text,
          tratamiento: _tratamientoController.text,
          estadoTratamiento: estadoNotifier.value!,
          idUsuario: idUsuario,
        );

        // ignore: use_build_context_synchronously
        final historialProveedor = Provider.of<HistorialProveedor>(context, listen: false);
        await historialProveedor.actualizarHistorial(historialActualizado);

        // Volver a la pantalla anterior
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // Manejo de error si no hay sesión activa
        _mostrarAlerta("No se ha encontrado un usuario logueado.");
      }
    }
  }
}

void _cancelarEdicion() {
    // Navegar a la pantalla de citas
    Navigator.pop(context);
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
                      margin: const EdgeInsets.only(top: 50.0, bottom: 30.0),
                      child: const Text(
                        'Editar enfermedad',
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
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                      width: 300, // Ajusta el ancho
                      height: 60, // Ajusta la altura
                      margin: const EdgeInsets.only(top: 10.0), // Margen externo
                      child: TextFormField(
                controller: _enfermedadController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la enfermedad',
                  labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black,), // Cambiar tamaño de letra                       
                        floatingLabelBehavior: FloatingLabelBehavior.never, // Controla la visibilidad al enfocar
                        floatingLabelStyle: const TextStyle(
                          fontSize: 0.0, // Tamaño de la etiqueta cuando está enfocado
                          color: Color(0xFF00B2FF), // Color de la etiqueta cuando está enfocado
                        ),   
                        filled: true, // Habilitar el fondo del TextField
                        fillColor: Colors.white, // Color de fondo blanco    
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0), // Border radius
                        borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // Color del borde
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0), // Border radius
                          borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // Color del borde
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0), // Border radius
                          borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // Color del borde al estar enfocado
                        ),
                         errorBorder: OutlineInputBorder( // Cambiado para evitar resaltar en rojo
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // No mostrar borde rojo
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // No mostrar borde rojo
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Espaciado interno       
                ),
                style: const TextStyle(fontSize: 20.0), // Cambiar tamaño de letra del texto ingresado
                 validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3 || value.length > 50 || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    _mostrarAlerta('El nombre de la enfermedad debe tener entre 3 y 50 letras, no debe estar vacío y no debe contener caracteres especiales ni acentos.');
                    return '';
                  }
                  return null;
                },
              ),
              ),
              Container(
                      width: 300, // Ajusta el ancho
                      height: 60, // Ajusta la altura
                      margin: const EdgeInsets.only(top: 40.0, bottom: 20.0), // Margen externo
                      child: TextFormField(
                controller: _tratamientoController,
                decoration: InputDecoration(
                  labelText: 'Tratamiento administrado',
                  labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black), // Cambiar tamaño de letra
                        floatingLabelBehavior: FloatingLabelBehavior.never, // Controla la visibilidad al enfocar
                        floatingLabelStyle: const TextStyle(
                          fontSize: 0.0, // Tamaño de la etiqueta cuando está enfocado
                          color: Color(0xFF00B2FF), // Color de la etiqueta cuando está enfocado
                        ),   
                        filled: true, // Habilitar el fondo del TextField
                        fillColor: Colors.white, // Color de fondo blanco    
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0), // Border radius
                        borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // Color del borde
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0), // Border radius
                          borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // Color del borde
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0), // Border radius
                          borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // Color del borde al estar enfocado
                        ),
                         errorBorder: OutlineInputBorder( // Cambiado para evitar resaltar en rojo
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // No mostrar borde rojo
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Color(0xFF00B2FF), width: 2.0), // No mostrar borde rojo
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Espaciado interno
                ),
                style: const TextStyle(fontSize: 20.0), // Cambiar tamaño de letra del texto ingresado
                 validator: (value) {
                  if (value == null || value.isEmpty || value.length < 4 || value.length > 500 || !RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s.,]').hasMatch(value)) {
                    _mostrarAlerta('El tratamiento debe tener entre 4 y 500 letras, no debe estar vacío y no debe contener caracteres especiales ni acentos.');
                    return '';
                  }
                  return null;
                },
              ), 
              ),  
              ValueListenableBuilder<String?>(
                valueListenable: estadoNotifier,
                builder: (context, estado, _) {
                  return  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text(
                          'Estado del tratamiento', // Etiqueta que aparece fuera del campo
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color.fromARGB(137, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: 305.0, // Ancho del contenedor
                          height: 47.0, // Altura del contenedor
                          margin: const EdgeInsets.only(top: 0.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // Fondo blanco
                          borderRadius: BorderRadius.circular(15.0), // Borde redondeado
                          border: Border.all(
                            color: const Color(0xFF00B2FF), // Color del borde
                            width: 2.0, // Ancho del borde
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButtonFormField<String>(
                     decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto, // Oculta la etiqueta al seleccionar
                            border: InputBorder.none, // Sin borde adicional
                            filled: true, // Activa el color de fondo
                            fillColor: Colors.white, // Fondo blanco en el campo de texto
                          ),
                    value: estado,
                    items: ['Terminado', 'En curso',]
                        .map((estado) => DropdownMenuItem(
                              value: estado,
                              child: Text(estado),
                            ))
                        .toList(),
                    onChanged: (val) => estadoNotifier.value = val,
                     validator: (value) {
                      if (value == null) {
                        _mostrarAlerta('Selecciona el estado del tratamiento.');
                        return '';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 0, 0, 0)),
                    isDense: true,
                  )
                  )
                  )
                  ]
                  );
                },
              ),
              Container(
                    margin: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                    child: ElevatedButton(
                onPressed: _actualizarHistorial,
                style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: const Color(0xFF00B2FF),
                      minimumSize: const Size(150, 50)
                      ),
                child: const Text('Guardar cambios', style: TextStyle(fontSize: 22.0),),
              ),
              ),
              Container(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 40.0),
                    child: ElevatedButton(
                onPressed: _cancelarEdicion,
                style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: const Color(0xFF00B2FF),
                      minimumSize: const Size(150, 50)
                      ),
                child: const Text('Cancelar',  style: TextStyle(fontSize: 22.0),),
              ),
              ),
            ],
          ),
        ),
       ]
      ),
     ),
      ),
    ),
    );
  }
}
