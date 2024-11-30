import 'package:flutter/material.dart';
import '../modelos/usuario_modelo.dart'; // Importa el modelo de Usuario
import '../proveedor/usuario_proveedor.dart'; // Importa el provider

class EditarPerfilScreen extends StatefulWidget {
  final Usuario usuario;

  const EditarPerfilScreen({super.key, required this.usuario});

  @override
  // ignore: library_private_types_in_public_api
  _EditarPerfilScreenState createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final UsuarioProvider _usuarioProvider = UsuarioProvider();

  final ValueNotifier<String?> especieNotifier = ValueNotifier(null);
  final ValueNotifier<String?> sexoNotifier = ValueNotifier(null);
  final ValueNotifier<String?> colorNotifier = ValueNotifier(null);

  late TextEditingController _nombreController;
  late TextEditingController _edadController;
  late TextEditingController _razaController;
  late TextEditingController _pesoController;
  late TextEditingController _correoController;
  late TextEditingController _usuarioController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.usuario.nombre);
    _edadController = TextEditingController(text: widget.usuario.edad.toString());
    especieNotifier.value = widget.usuario.especie;
    sexoNotifier.value = widget.usuario.sexo;
    _razaController = TextEditingController(text: widget.usuario.raza);
    colorNotifier.value = widget.usuario.color;
    _pesoController = TextEditingController(text: widget.usuario.peso.toString());
    _correoController = TextEditingController(text: widget.usuario.correo);
    _usuarioController = TextEditingController(text: widget.usuario.usuario);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _razaController.dispose();
    _pesoController.dispose();
    _correoController.dispose();
    _usuarioController.dispose();
    super.dispose();
  }

  String? _mensajeError;

  bool _validarPerfil() {
    // Validación de Nombre
    if (_nombreController.text.isEmpty || 
        _nombreController.text.length < 3 || 
        _nombreController.text.length > 50 || 
        !RegExp(r'^[a-zA-Z\s]+$').hasMatch(_nombreController.text)) {
      _mensajeError = "El nombre debe tener entre 3 y 50 letras y no debe estar vacío.";
      return false;
    }

    // Validación de Edad
    if (_edadController.text.isEmpty || 
        _edadController.text.length > 2 || 
        int.tryParse(_edadController.text) == null || 
        int.parse(_edadController.text) <= 0) {
      _mensajeError = "La edad debe ser un número positivo, no debe estar vacía y no tener más de dos dígitos.";
      return false;
    }

    // Validación de Especie
    if (especieNotifier.value == null) {
      _mensajeError = "Por favor, selecciona una especie.";
      return false;
    }

    // Validación de Especie
    if (sexoNotifier.value == null) {
      _mensajeError = "Por favor, selecciona un tipo se sexo";
      return false;
    }

    // Validación de Raza
    if (_razaController.text.isEmpty || 
        _razaController.text.length < 3 || 
        _razaController.text.length > 25 || 
        !RegExp(r'^[a-zA-Z\s]+$').hasMatch(_razaController.text)) {
      _mensajeError = "La raza debe tener entre 3 y 25 letras y no debe estar vacía.";
      return false;
    }

    // Validación de Color
    if (colorNotifier.value == null) {
      _mensajeError = "Por favor, selecciona un color.";
      return false;
    }

    // Validación de Peso
    if (_pesoController.text.isEmpty || 
        double.tryParse(_pesoController.text) == null || 
        double.parse(_pesoController.text) <= 0) {
      _mensajeError = "El peso debe ser un número positivo y no debe estar vacío.";
      return false;
    }

    // Validación de Correo
    if (_correoController.text.isEmpty || 
        _correoController.text.length < 10 ||  
        _correoController.text.length > 75 ||  
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(_correoController.text)) {
      _mensajeError = "Por favor, ingresa un correo electrónico válido.";
      return false;
    }

    // Validación de Usuario
    if (_usuarioController.text.isEmpty || 
        _usuarioController.text.length < 3 || 
        _usuarioController.text.length > 15 || 
        !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(_usuarioController.text)) {
      _mensajeError = "El usuario debe tener entre 3 y 15 letras o números y no debe estar vacío.";
      return false;
    }

    // Si pasa todas las validaciones
    _mensajeError = null;
    return true;
  }

  Future<void> _guardarCambios() async {
    if (_validarPerfil()) {
      Usuario usuarioActualizado = Usuario(
        idUsuario: widget.usuario.idUsuario,
        nombre: _nombreController.text,
        edad: int.parse(_edadController.text),
        especie: especieNotifier.value ?? '',
        sexo: sexoNotifier.value ?? '',
        raza: _razaController.text,
        color: colorNotifier.value ?? '',
        peso: double.parse(_pesoController.text),
        correo: _correoController.text,
        usuario: _usuarioController.text,
        password: widget.usuario.password, // Conserva la contraseña existente
      );

      bool actualizado = await _usuarioProvider.actualizarPerfil(usuarioActualizado);
      if (actualizado) {
      // Mostrar un diálogo de éxito y redirigir al perfil
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Éxito'),
            content: const Text('El perfil se actualizó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el diálogo
                  Navigator.pop(context, usuarioActualizado); // Regresar a la pantalla de perfil
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      // Mostrar un diálogo de error y permanecer en la página de edición
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Hubo un error al actualizar el perfil.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }else {
    // Mostrar mensaje de error si alguna validación falla
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(_mensajeError ?? "Error desconocido."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
              ),              
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ingrese su edad' : null,
              ),
               ValueListenableBuilder<String?>(
                valueListenable: sexoNotifier,
                builder: (context, sexo, _) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Sexo',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: sexo,
                    items: ['Macho', 'Hembra',]
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (val) => sexoNotifier.value = val,
                    validator: (value) => value == null ? 'Seleccione el sexo' : null,
                  );
                },
              ),
              ValueListenableBuilder<String?>(
                valueListenable: especieNotifier,
                builder: (context, especie, _) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Especie',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: especie,
                    items: ['Gato', 'Perro', 'Ave', 'Pez', 'Hámster', 'Conejo', 'Tortuga']
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (val) => especieNotifier.value = val,
                    validator: (value) => value == null ? 'Seleccione la especie' : null,
                  );
                },
              ),             
              TextFormField(
                controller: _razaController,
                decoration: const InputDecoration(labelText: 'Raza'),
                validator: (value) => value!.isEmpty ? 'Ingrese la raza' : null,
              ),
              ValueListenableBuilder<String?>(
                valueListenable: colorNotifier,
                builder: (context, color, _) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: color,
                    items: ['Negro', 'Blanco', 'Café', 'Amarillo', 'Manchado', 'Naranja', 'Verde', 'Azul', 'Borrado']
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (val) => colorNotifier.value = val,
                    validator: (value) => value == null ? 'Seleccione el color' : null,
                  );
                },
              ),
              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(labelText: 'Peso'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ingrese el peso' : null,
              ),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) => value!.isEmpty ? 'Ingrese su correo' : null,
              ),
              TextFormField(
                controller: _usuarioController,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: (value) => value!.isEmpty ? 'Ingrese su nombre de usuario' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

