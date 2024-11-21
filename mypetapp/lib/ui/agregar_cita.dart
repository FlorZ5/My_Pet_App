import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/cita_modelo.dart';
import '../proveedor/cita_proveedor.dart';
import 'citas.dart';
import '../utils/session_manager.dart';

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
                  suffixIcon: Icon(Icons.calendar_today), // Icono de calendario para indicar la selección de fecha
                ),
                readOnly: true, // Evita que el usuario escriba manualmente
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), // Fecha inicial
                    firstDate: DateTime.now(), // Fecha mínima
                    lastDate: DateTime(2099), // Fecha máxima
                  );

                  if (pickedDate != null) {
                    String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    _fechaController.text = formattedDate; // Asigna la fecha seleccionada al controlador
                  }
                },
                validator: (value) => value!.isEmpty ? 'Ingrese la fecha' : null,
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
                validator: (value) => value!.isEmpty ? 'Ingrese la hora' : null,
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
                    validator: (value) =>
                        value == null ? 'Seleccione el tipo de cita' : null,
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