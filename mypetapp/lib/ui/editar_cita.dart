import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/cita_modelo.dart';
import '../proveedor/cita_proveedor.dart';
import '../utils/session_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController(text: widget.cita.fecha);
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
      appBar: AppBar(
        title: const Text('Editar Cita'),
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
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    _fechaController.text = formattedDate;
                  }
                },
                validator: (value) => value!.isEmpty ? 'Ingrese la fecha' : null,
              ),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final formattedTime = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                    _horaController.text = formattedTime;
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
                    items: [
                      'Consulta', 'Revisión', 'Vacunación', 'Desparacitación',
                      'Control reproductivo', 'Especialidades', 'Examenes de laboratorío',
                      'Asesoria nutricional', 'Chequeo geriátrico', 'Radiografía', 'Cirugía'
                    ]
                        .map((tipoCita) => DropdownMenuItem(
                              value: tipoCita,
                              child: Text(tipoCita),
                            ))
                        .toList(),
                    onChanged: (val) => tipoCitaNotifier.value = val,
                    validator: (value) => value == null ? 'Seleccione el tipo de cita' : null,
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _actualizarCita,
                child: const Text('Actualizar Cita'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _cancelarEdicion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
