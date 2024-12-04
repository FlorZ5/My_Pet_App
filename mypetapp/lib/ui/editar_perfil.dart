import 'package:flutter/material.dart';
import '../modelos/usuario_modelo.dart'; // Importa el modelo de Usuario
import '../proveedor/usuario_proveedor.dart'; // Importa el provider
import 'agregar_cita.dart';
import 'agregar_historial.dart';
import 'agregar_vacuna.dart';
import 'clinicas.dart';
import 'conocenos.dart';
import 'contactos.dart';
import 'inicio_screen.dart';

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
      _mensajeError = "El nombre de la mascota debe tener entre 3 y 50 letras, no debe estar vacío y no contener caracteres especiales ni acentos.";
      return false;
    }

    // Validación de Edad
    if (_edadController.text.isEmpty || 
        _edadController.text.length > 2 || 
        int.tryParse(_edadController.text) == null || 
        int.parse(_edadController.text) <= 0) {
      _mensajeError = "La edad de la mascota debe ser un número positivo, no debe estar vacía y no tener más de dos dígitos.";
      return false;
    }

    // Validación de Especie
    if (especieNotifier.value == null) {
      _mensajeError = "Por favor, selecciona el sexo de la mascota.";
      return false;
    }

    // Validación de Especie
    if (sexoNotifier.value == null) {
      _mensajeError = "Por favor, selecciona la especie de la mascota.";
      return false;
    }

    // Validación de Raza
    if (_razaController.text.isEmpty || 
        _razaController.text.length < 3 || 
        _razaController.text.length > 25 || 
        !RegExp(r'^[a-zA-Z\s]+$').hasMatch(_razaController.text)) {
      _mensajeError = "La raza de la mascota debe tener entre 3 y 25 letras, no debe estar vacía y no contener caracteres especiales ni acentos.";
      return false;
    }

    // Validación de Color
    if (colorNotifier.value == null) {
      _mensajeError = "Por favor, selecciona el color de la mascota.";
      return false;
    }

    // Validación de Peso
    if (_pesoController.text.isEmpty || 
        double.tryParse(_pesoController.text) == null || 
        double.parse(_pesoController.text) <= 0) {
      _mensajeError = "El peso de la mascota debe ser un número positivo, no debe estar vacio y puede contener un punto decimal.";
      return false;
    }

    // Validación de Correo
    if (_correoController.text.isEmpty || 
        _correoController.text.length < 10 ||  
        _correoController.text.length > 75 ||  
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(_correoController.text)) {
      _mensajeError = "El correo electronico del dueño debe ser valido y tener una estructura correcta.";
      return false;
    }

    // Validación de Usuario
    if (_usuarioController.text.isEmpty || 
        _usuarioController.text.length < 3 || 
        _usuarioController.text.length > 15 || 
        !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(_usuarioController.text)) {
      _mensajeError = "El usuario debe tener entre 3 y 15 letras o números,  no debe estar vacío, no tener más de dos números y no contener caracteres especiales, acentos o espacios.";
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
      // Redirigir directamente a la pantalla de perfil
      // ignore: use_build_context_synchronously
      Navigator.pop(context, usuarioActualizado); // Regresar a la pantalla de perfil con datos actualizados
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
                        'Perfil',
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
                        'Editar perfil',
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
                margin: const EdgeInsets.only(top: 40.0), // Margen externo
                child: TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la mascota',
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Espaciado interno
                    ),
                    style: const TextStyle(fontSize: 20.0), // Cambiar tamaño de letra del texto ingresado
                    ),
                  ),              
             Container(
        width: 300, // Ajusta el ancho
        height: 60, // Ajusta la altura
        margin: const EdgeInsets.only(top: 40.0, bottom: 20.0), // Margen externo
        child: TextFormField(
          controller: _edadController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Edad de la mascota en años',            
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
              contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Espaciado interno
            ),
            style: const TextStyle(fontSize: 20.0), // Cambiar tamaño de letra del texto ingresado
            ),
          ),
              ValueListenableBuilder<String?>(
              valueListenable: sexoNotifier,
              builder: (context, sexo, _) {
              return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sexo de la mascota', // Etiqueta que aparece fuera del campo
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromARGB(137, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 8.0),
              Container(
                width: 305.0, // Ancho del contenedor
                height: 47.0, // Altura del contenedor
                margin: const EdgeInsets.only(bottom: 30.0),
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
                  value: sexo,
                  items: ['Macho', 'Hembra',]
                      .map((sexo) => DropdownMenuItem(
                            value: sexo,
                            
                            child: Text(
                              sexo,
                              style: const TextStyle(fontSize: 20.0),

                            ),
                          ))
                      .toList(),
                  onChanged: (val) => sexoNotifier.value = val,
                  style: const TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 0, 0, 0)
                  ),
                )
                )
                ]
                );
              },
            ),
              ValueListenableBuilder<String?>(
              valueListenable: especieNotifier,
              builder: (context, especie, _) {
              return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Especie de la mascota', // Etiqueta que aparece fuera del campo
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromARGB(137, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 8.0),
              Container(
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
                  value: especie,
                  items: ['Gato', 'Perro', 'Ave', 'Pez', 'Hámster', 'Conejo', 'Tortuga']
                      .map((especie) => DropdownMenuItem(
                            value: especie,                            
                            child: Text(
                              especie,
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) => especieNotifier.value = val,
                  style: const TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 0, 0, 0)),
                )
                )
                ]
                );
              },
            ),           
               Container(
        width: 300, // Ajusta el ancho
        height: 60, // Ajusta la altura
        margin: const EdgeInsets.only(top: 40.0, bottom: 20.0), // Margen externo
        child: TextFormField(
          controller: _razaController,
          decoration: InputDecoration(
            labelText: 'Raza de la mascota',                       
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
              contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Espaciado interno
            ),            
            style: const TextStyle(fontSize: 20.0), // Cambiar tamaño de letra del texto ingresado
            ),
          ),
               ValueListenableBuilder<String?>(
              valueListenable: colorNotifier,
              builder: (context, color, _) {
                return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Color de la mascota', // Etiqueta que aparece fuera del campo
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromARGB(137, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 8.0),
              Container(
                width: 305.0, // Ancho del contenedor
                height: 47.0, // Altura del contenedor
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
                  value: color,
                  items: ['Negro', 'Blanco', 'Café', 'Amarillo', 'Manchado', 'Naranja', 'Verde', 'Azul', 'Borrado']
                      .map((especie) => DropdownMenuItem(
                            value: especie,
                            child: Text(
                              especie,
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) => colorNotifier.value = val,                  
                  style: const TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 0, 0, 0)
                )
              )
              )
               ]            
              );
              },
            ),
              Container(
        width: 300, // Ajusta el ancho
        height: 60, // Ajusta la altura
        margin: const EdgeInsets.only(top: 40.0), // Margen externo
        child: TextFormField(
          controller: _pesoController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Peso de la mascota en kilos',            
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
              contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Espaciado interno
            ),
            style: const TextStyle(fontSize: 20.0), // Cambiar tamaño de letra del texto ingresado
            ),
          ),
              Container(
        width: 300, // Ajusta el ancho
        height: 60, // Ajusta la altura
        margin: const EdgeInsets.only(top: 40.0), // Margen externo
        child: TextFormField(
          controller: _correoController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo electrónico del dueño',            
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
              contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Espaciado interno
            ),
            style: const TextStyle(fontSize: 20.0), // Cambiar tamaño de letra del texto ingresado
            ),
          ),
               Container(
        width: 300, // Ajusta el ancho
        height: 60, // Ajusta la altura
        margin: const EdgeInsets.only(top: 40.0), // Margen externo
        child: TextFormField(
          controller: _usuarioController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Usuario',            
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
              contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Espaciado interno
            ),
            style: const TextStyle(fontSize: 20.0), // Cambiar tamaño de letra del texto ingresado            
            ),
          ),
              Container(
                    margin: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                    child: ElevatedButton(
                onPressed: _guardarCambios,
                 style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: const Color(0xFF00B2FF),
                      minimumSize: const Size(150, 50)
                      ),
                child: const Text('Guardar cambios',  style: TextStyle(fontSize: 22.0),),
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

