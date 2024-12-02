import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/cita_modelo.dart';
import '../proveedor/cita_proveedor.dart';
import '../utils/session_manager.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'agregar_historial.dart';
import 'agregar_vacuna.dart';
import 'clinicas.dart';
import 'conocenos.dart';
import 'contactos.dart';
import 'perfil.dart';
import 'inicio_screen.dart';

class EditarCitaScreen extends StatefulWidget {
  final Cita cita;

  const EditarCitaScreen({super.key, required this.cita});

  @override
  // ignore: library_private_types_in_public_api
  _EditarCitaScreenState createState() => _EditarCitaScreenState();
}

class _EditarCitaScreenState extends State<EditarCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fechaController;
  late TextEditingController _horaController;
  final tipoCitaNotifier = ValueNotifier<String?>(null);
  bool _alertaMostrando = false;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController(text: widget.cita.fecha);
    selectedDate = DateFormat('dd/MM/yyyy').parse(widget.cita.fecha);
    _horaController = TextEditingController(text: widget.cita.hora);
    tipoCitaNotifier.value = widget.cita.tipo;
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _horaController.dispose();
     tipoCitaNotifier.dispose();
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

  void _actualizarCita() async {
    if (_formKey.currentState!.validate()) {
      final idUsuarioString = await SessionManager.getUserId();
      if (idUsuarioString != null) {
        final idUsuario = int.tryParse(idUsuarioString);
      if (idUsuario != null) {
        final citaActualizada = Cita(
          idCita: widget.cita.idCita,
          fecha: _fechaController.text,
          hora: _horaController.text,
          tipo: tipoCitaNotifier.value!,
          idUsuario: idUsuario,  // Asociamos la cita con el idUsuario
        );

        // ignore: use_build_context_synchronously
        final citaProveedor = Provider.of<CitaProveedor>(context, listen: false);
        await citaProveedor.actualizarCita(citaActualizada);

        // Volver a la pantalla anterior
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
  // Manejo de error si no hay sesión activa
  showDialog(
    // ignore: use_build_context_synchronously
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Error"),
        content: const Text("No se ha encontrado un usuario logueado."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text("Aceptar"),
          ),
        ],
      );
    },
  );
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
                    const Text(
                      'Citas',
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
                                MaterialPageRoute(builder: (context) => const PaginaInicio()), 
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
                                  'lib/assets/inicio.png', // Ruta ícono
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
                        'Editar cita',
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
                        controller: _fechaController,
                        decoration: InputDecoration(
                        labelText: 'Fecha de la cita',
                        labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black,), // Cambiar tamaño de letra                        
                        suffixIcon: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 0, 0, 0),), // Icono de calendario    
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
                readOnly: true,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 300, // Limitar la altura del calendario
                            ),
                          child: SizedBox(
                          height: 300,
                          width: 300,
                           child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          child: DayPicker.single(
                            selectedDate: selectedDate,
                            onChanged: (DateTime date) {
                              setState(() {
                                selectedDate = date;
                                _fechaController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                              });
                              Navigator.pop(context);
                            },
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2099),
                          ),
                        ),
                        )
                        )
                      );
                    },
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _mostrarAlerta('Ingresa la fecha de la cita.');
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
                    child:TextFormField(
                      controller: _horaController,
                      decoration: InputDecoration(
                        labelText: 'Hora de la cita',
                        labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black), // Cambiar tamaño de letra
                        suffixIcon: const Icon(Icons.access_time,  color: Color.fromARGB(255, 0, 0, 0),), // Icono de reloj para indicar la selección de hora
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
                      readOnly: true, // Evita que el usuario escriba manualmente
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(), // Hora inicial
                        );
                        if (pickedTime != null) {
                          final now = DateTime.now();
                          // ignore: unused_local_variable
                          final selectedTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                          final formattedTime = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                          _horaController.text = formattedTime; // Asigna la hora seleccionada al controlador
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _mostrarAlerta('Ingresa la hora de la cita.');
                          return '';
                        }
                        return null;
                      },
                    ),
                    ),
                    ValueListenableBuilder<String?>(
                      valueListenable: tipoCitaNotifier,
                      builder: (context, tipo, _) {
                        return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text(
                          'Tipo de cita', // Etiqueta que aparece fuera del campo
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
                          value: tipo,
                          isExpanded: true,
                          items: ['Consulta', 'Revisión', 'Vacunación', 'Desparacitación', 'Control reproductivo', 'Especialidades', 'Examenes de laboratorío', 'Asesoria nutricional', 'Chequeo geriátrico', 'Radiografía', 'Cirugía']
                              .map((tipoCita) => DropdownMenuItem(
                                    value: tipoCita,
                                    child: Text(tipoCita),
                                  ))
                              .toList(),
                          onChanged: (val) => tipoCitaNotifier.value = val,
                          validator: (value) {
                            if (value == null) {
                              _mostrarAlerta('Selecciona el tipo de cita.');
                              return '';
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 0, 0, 0)),
                          isDense: true,
                        ),
                        ),
                        ),
                        ]
                        );
                      },
                    ),
              Container(
                    margin: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                    child:ElevatedButton(
                onPressed: _actualizarCita,
                style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: const Color(0xFF00B2FF),
                      minimumSize: const Size(150, 50)
                      ),
                child: const Text('Guardar cambios', style: TextStyle(fontSize: 22.0),),
              ),
              ),
              const SizedBox(height: 10),
              Container(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 40.0),
                    child:ElevatedButton(
                onPressed: _cancelarEdicion,
                style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: const Color(0xFF00B2FF),
                      minimumSize: const Size(150, 50)
                      ),
                child: const Text('Cancelar', style: TextStyle(fontSize: 22.0),),
              ),
              ),
            ],
          ),
        ),
       ]
      ),
      )
    )
    )
    );
  }
}
