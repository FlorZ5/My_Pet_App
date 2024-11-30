import 'package:flutter/material.dart';
import 'package:mypetapp/modelos/historial_modelo.dart';
import 'package:mypetapp/proveedor/historial_proveedor.dart';
import 'package:provider/provider.dart';
import '../utils/session_manager.dart';

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
      appBar: AppBar(
        title: const Text('Editar enfermedad'),
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
                onPressed: _actualizarHistorial,
                child: const Text('Actualizar historial'),
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
