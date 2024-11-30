import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/cita_modelo.dart';
import '../proveedor/cita_proveedor.dart';
import 'citas.dart';
import '../utils/session_manager.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';

class FormularioCitaScreen extends StatefulWidget {
  const FormularioCitaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormularioCitaScreenState createState() => _FormularioCitaScreenState();
}

class _FormularioCitaScreenState extends State<FormularioCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fechaController;
  late TextEditingController _horaController;
  final ValueNotifier<String?> tipoCitaNotifier = ValueNotifier<String?>(null);
  bool _alertaMostrando = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController();
    _horaController = TextEditingController();
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

  void _guardarCita() async {
    if (_formKey.currentState!.validate()) {
      // Usamos SessionManager para obtener el idUsuario
      final idUsuarioString = await SessionManager.getUserId();
      if (idUsuarioString != null) {
        final idUsuario = int.tryParse(idUsuarioString);

      if (idUsuario != null) {
        final cita = Cita(
          fecha: _fechaController.text,
          hora: _horaController.text,
          tipo: tipoCitaNotifier.value!,
          idUsuario: idUsuario,  // Asociamos la cita con el idUsuario
        );

        // ignore: use_build_context_synchronously
        final citaProveedor = Provider.of<CitaProveedor>(context, listen: false);
        await citaProveedor.agregarCita(cita);

        // Ir a la pantalla de citas
        Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const CitasScreen()),
        );
      } else {
        // Manejo de error si no hay sesión activa
        _mostrarAlerta("No se ha encontrado un usuario logueado.");
      }
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  suffixIcon: Icon(Icons.calendar_today), // Icono de calendario
                ),
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
                    _mostrarAlerta('Ingrese la fecha de la cita.');
                    return '';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  suffixIcon: Icon(Icons.access_time), // Icono de reloj para indicar la selección de hora
                ),
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
                    _mostrarAlerta('Ingrese la hora de la cita.');
                    return '';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String?>(
                valueListenable: tipoCitaNotifier,
                builder: (context, tipo, _) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Cita',
                      border: OutlineInputBorder(),
                    ),
                    value: tipo,
                    items: ['Consulta', 'Revisión', 'Vacunación', 'Desparacitación', 'Control reproductivo', 'Especialidades', 'Examenes de laboratorío', 'Asesoria nutricional', 'Chequeo geriátrico', 'Radiografía', 'Cirugía']
                        .map((tipoCita) => DropdownMenuItem(
                              value: tipoCita,
                              child: Text(tipoCita),
                            ))
                        .toList(),
                    onChanged: (val) => tipoCitaNotifier.value = val,
                     validator: (value) {
                      if (value == null) {
                        _mostrarAlerta('Seleccione el tipo de cita.');
                        return '';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCita,
                child: const Text('Guardar Cita'),
              ),
               const SizedBox(height: 10), // Espacio entre los botones
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CitasScreen()),
                  );
                },
                child: const Text('Ver Citas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}