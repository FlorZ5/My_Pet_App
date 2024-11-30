import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../modelos/historial_modelo.dart';
import '../proveedor/historial_proveedor.dart';
import 'historial.dart';
import '../utils/session_manager.dart';

class FormularioHistorialScreen extends StatefulWidget {
  const FormularioHistorialScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormularioHistorialScreenState createState() => _FormularioHistorialScreenState();
}

class _FormularioHistorialScreenState extends State<FormularioHistorialScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _enfermedadController;
  late TextEditingController _tratamientoController;
  final ValueNotifier<String?> estadoNotifier = ValueNotifier<String?>(null);
  bool _alertaMostrando = false;

  @override
  void initState() {
    super.initState();
    _enfermedadController = TextEditingController();
    _tratamientoController = TextEditingController();
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

  void _guardarHistorial() async {
    if (_formKey.currentState!.validate()) {
      // Usamos SessionManager para obtener el idUsuario
      final idUsuarioString = await SessionManager.getUserId();
      if (idUsuarioString != null) {
        final idUsuario = int.tryParse(idUsuarioString);

      if (idUsuario != null) {
        final historial = Historial(
          enfermedad: _enfermedadController.text,
          tratamiento: _tratamientoController.text,
          estadoTratamiento: estadoNotifier.value!,
          idUsuario: idUsuario,  // Asociamos la cita con el idUsuario
        );

        // ignore: use_build_context_synchronously
        final historialProveedor = Provider.of<HistorialProveedor>(context, listen: false);
        await historialProveedor.agregarHistorial(historial);

        // Ir a la pantalla historial
        Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HistorialScreen()),
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
        title: const Text('Agregar historial'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _enfermedadController,
                decoration: const InputDecoration(
                  labelText: 'Enfermedad',
                ),
                 validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3 || value.length > 50 || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    _mostrarAlerta('El nombre de la enfermedad debe tener entre 3 y 50 letras y no debe estar vacío.');
                    return '';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tratamientoController,
                decoration: const InputDecoration(
                  labelText: 'Tratamiento',
                ),
                 validator: (value) {
                  if (value == null || value.isEmpty || value.length < 4 || value.length > 500 || !RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s.,]').hasMatch(value)) {
                    _mostrarAlerta('El tratamiento debe tener entre 4 y 500 letras y no debe estar vacío.');
                    return '';
                  }
                  return null;
                },
              ),             
              const SizedBox(height: 20),
              ValueListenableBuilder<String?>(
                valueListenable: estadoNotifier,
                builder: (context, estado, _) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Estado del tratamiento',
                      border: OutlineInputBorder(),
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
                        _mostrarAlerta('Seleccione el estado del tratamiento.');
                        return '';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarHistorial,
                child: const Text('Guardar enfermedad'),
              ),
               const SizedBox(height: 10), // Espacio entre los botones
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistorialScreen()),
                  );
                },
                child: const Text('Ver Historial'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}