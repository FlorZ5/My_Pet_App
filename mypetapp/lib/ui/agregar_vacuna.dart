import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/vacunas_modelo.dart';
import '../proveedor/vacuna_proveedor.dart';
import 'vacunas.dart';
import '../utils/session_manager.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';

class FormularioVacunaScreen extends StatefulWidget {
  const FormularioVacunaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormularioVacunaScreen createState() => _FormularioVacunaScreen();
}

class _FormularioVacunaScreen extends State<FormularioVacunaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _marcaController;
  late TextEditingController _fechaController;
  final ValueNotifier<String?> dosisNotifier = ValueNotifier<String?>(null);
  bool _alertaMostrando = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _marcaController = TextEditingController();
    _fechaController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    dosisNotifier.dispose();
    _marcaController.dispose();
    _fechaController.dispose();
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

  void _guardarVacuna() async {
    if (_formKey.currentState!.validate()) {
      // Usamos SessionManager para obtener el idUsuario
      final idUsuarioString = await SessionManager.getUserId();
      if (idUsuarioString != null) {
        final idUsuario = int.tryParse(idUsuarioString);

      if (idUsuario != null) {
        final vacuna = Vacuna(
          nombre: _nombreController.text,
          dosis: dosisNotifier.value!,
          marca: _marcaController.text,
          fecha: _fechaController.text,
          idUsuario: idUsuario,  // Asociamos la cita con el idUsuario
        );

        // ignore: use_build_context_synchronously
        final vacunaProveedor = Provider.of<VacunaProveedor>(context, listen: false);
        await vacunaProveedor.agregarVacuna(vacuna);

        // Ir a la pantalla vacunas
        Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const VacunasScreen()),
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
        title: const Text('Agregar Vacuna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la vacuna',
                ),
                 validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3 || value.length > 50 || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    _mostrarAlerta('El nombre de la vacuna debe tener entre 3 y 50 letras y no debe estar vacío.');
                    return '';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String?>(
                valueListenable: dosisNotifier,
                builder: (context, tipo, _) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de dosis',
                      border: OutlineInputBorder(),
                    ),
                    value: tipo,
                    items: ['Unica', 'Inicial', 'Refuerzo', 'Primaria', 'De recordatorio', 'De urgencia', 'De campaña', 'De mandenimiento', 'De desensibilización', 'De prueba']
                        .map((tipoVacuna) => DropdownMenuItem(
                              value: tipoVacuna,
                              child: Text(tipoVacuna),
                            ))
                        .toList(),
                    onChanged: (val) => dosisNotifier.value = val,
                    validator: (value) {
                      if (value == null) {
                        _mostrarAlerta('Seleccione el tipo de dosis.');
                        return '';
                      }
                      return null;
                    },
                  );
                },
              ),
               TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(
                  labelText: 'Marca de la vacuna',
                ),
                 validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2 || value.length > 30 || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)){
                    _mostrarAlerta('La marca de la vacuna debe tener entre 3 y 50 letras y no debe estar vacío.');
                    return '';
                  }
                  return null;
                },
              ),
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
                    _mostrarAlerta('Ingrese la fecha de vacunación.');
                    return '';
                  }
                  return null;
                },
              ),               
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarVacuna,
                child: const Text('Registrar vacuna'),
              ),
               const SizedBox(height: 10), // Espacio entre los botones
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VacunasScreen()),
                  );
                },
                child: const Text('Ver Vacunas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
