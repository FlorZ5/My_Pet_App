import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/vacunas_modelo.dart';
import '../proveedor/vacuna_proveedor.dart';
import '../utils/session_manager.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';

class EditarVacunaScreen extends StatefulWidget {
  final Vacuna vacuna;

  const EditarVacunaScreen({super.key, required this.vacuna});

  @override
  // ignore: library_private_types_in_public_api
  _EditarVacunaScreenState createState() => _EditarVacunaScreenState();
}

class _EditarVacunaScreenState extends State<EditarVacunaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;  
  late TextEditingController _marcaController;
  late TextEditingController _fechaController;
  final dosisNotifier = ValueNotifier<String?>(null);
  bool _alertaMostrando = false;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.vacuna.nombre);
    _marcaController = TextEditingController(text: widget.vacuna.marca);
    _fechaController = TextEditingController(text: widget.vacuna.fecha);
    selectedDate = DateFormat('dd/MM/yyyy').parse(widget.vacuna.fecha);
    dosisNotifier.value = widget.vacuna.dosis;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _marcaController.dispose();
    _fechaController.dispose();
     dosisNotifier.dispose();
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

  void _actualizarVacuna() async {
    if (_formKey.currentState!.validate()) {
      final idUsuarioString = await SessionManager.getUserId();
      if (idUsuarioString != null) {
        final idUsuario = int.tryParse(idUsuarioString);
      if (idUsuario != null) {
        final vacunaActualizada = Vacuna(
          idVacuna: widget.vacuna.idVacuna,
          nombre: _nombreController.text,
          marca: _marcaController.text,
          fecha: _fechaController.text,
          dosis: dosisNotifier.value!,
          idUsuario: idUsuario,
        );

        // ignore: use_build_context_synchronously
        final vacunaProveedor = Provider.of<VacunaProveedor>(context, listen: false);
        await vacunaProveedor.actualizarVacuna(vacunaActualizada);

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
        title: const Text('Editar vacuna'),
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
                  labelText: 'Nombre',
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
                builder: (context, dosis, _) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Dosis de la vacuna',
                      border: OutlineInputBorder(),
                    ),
                    value: dosis,
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
                  labelText: 'Marca',
                ),
                 validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2 || value.length > 30 || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)){
                    _mostrarAlerta('La marca de la vacuna debe tener entre 3 y 50 letras y no debe estar vacío.');
                    return '';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 300,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: DayPicker.single(
                              selectedDate: selectedDate,
                              onChanged: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  _fechaController.text =
                                      DateFormat('dd/MM/yyyy').format(selectedDate);
                                });
                                Navigator.pop(context);
                              },
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2099),
                            ),
                          ),
                        ),
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
                onPressed: _actualizarVacuna,
                child: const Text('Actualizar Vacuna'),
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
