import 'package:flutter/material.dart';
import '../modelos/usuario_modelo.dart';
import '../proveedor/usuario_proveedor.dart';
import 'login_screen.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  final UsuarioProvider _usuarioProvider = UsuarioProvider();

  // Controladores de texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController razaController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  //listas desplegables
  final ValueNotifier<String?> especieNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> sexoNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> colorNotifier = ValueNotifier<String?>(null);

  RegisterScreen({super.key});

  String? _mensajeError;

  bool _validarEntrada() {
    // Validación de Nombre
    if (nombreController.text.isEmpty || nombreController.text.length < 3 ||  nombreController.text.length > 50 || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(nombreController.text)) {
     _mensajeError = "El nombre debe tener entre 3 y 50 letras y no debe estar vacío.";
     return false;
    }

    // Validación de Edad
    if (edadController.text.isEmpty || edadController.text.length > 2 || int.tryParse(edadController.text) == null || int.parse(edadController.text) <= 0) {
      _mensajeError= "La edad debe ser un número positivo, no debe estar vacía y no tener más de dos dígitos.";
      return false;
    }

    // Validación de Sexo
        if (sexoNotifier.value == null) {
          _mensajeError= "Por favor, selecciona un tipo de sexo.";
          return false;
        }

    // Validación de Especie
    if (especieNotifier.value == null) {
      _mensajeError= "Por favor, selecciona una especie.";
      return false;
    }  

    // Validación de Raza
    if (razaController.text.isEmpty || razaController.text.length < 3 || edadController.text.length > 25 || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(razaController.text)) {
      _mensajeError= "La raza debe tener entre 3 y 25 letras y no debe estar vacía.";
      return false;
    }

    // Validación de Color
    if (colorNotifier.value == null) {
      _mensajeError= "Por favor, selecciona un color.";
      return false;
    }

    // Validación de Peso
    if (pesoController.text.isEmpty || double.tryParse(pesoController.text) == null || double.parse(pesoController.text) <= 0) {
      _mensajeError= "El peso debe ser un número positivo y no debe estar vacío.";
      return false;
    }

    // Validación de Correo
    if (correoController.text.isEmpty || correoController.text.length < 10 ||  correoController.text.length > 75 ||  !RegExp(r'^[a-zA-Z0-9](?:[a-zA-Z0-9._%+-]*[a-zA-Z0-9])?@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(correoController.text)) {
     _mensajeError= "Por favor, ingresa un correo electrónico válido.";
     return false;
    }

    // Validación de Usuario
    if (usuarioController.text.isEmpty || usuarioController.text.length < 3 || usuarioController.text.length > 15 || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(usuarioController.text)) {
      _mensajeError= "El usuario debe tener entre 3 y 15 letras o numeros y no debe estar vacío.";
      return false;
    }

    // Validación de Contraseña
    if (passwordController.text.isEmpty || passwordController.text.length < 8 || 
        !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+$').hasMatch(passwordController.text)) {
      _mensajeError= "La contraseña debe tener 8 caracteres y contener al menos una letra y un número.";
      return false;
    }

    // Si pasa todas las validaciones
  _mensajeError = null;
  return true;
  }

  Future<void> _registrar(BuildContext context) async {    

    if (!_validarEntrada()) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error de validación"),
          content: Text(_mensajeError ?? "Por favor, completa todos los campos correctamente."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
    return; // Salimos de la función si la validación falla
  }

    Usuario usuario = Usuario(
      nombre: nombreController.text,
      edad: int.tryParse(edadController.text) ?? 0,
      especie: especieNotifier.value ?? "Especie",
      sexo: sexoNotifier.value ?? "Sexo",
      raza: razaController.text,
      color: colorNotifier.value ?? "Color",
      peso: double.tryParse(edadController.text) ?? 0,
      correo: correoController.text,
      usuario: usuarioController.text,
      password: passwordController.text,
    );

    bool success = await _usuarioProvider.registrarUsuario(usuario);
    
    if (success) {
      // Muestra el diálogo de éxito
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Registro exitoso"),
            content: const Text("El usuario se ha registrado correctamente."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ); // Navega a la pantalla de inicio de sesión
                },
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );
    } else {
      // Muestra un mensaje de error      
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("El usuario ya existe."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                },
                child: const Text("Aceptar"),
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
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center( // Centra el contenido horizontalmente
        child: Padding(          
        padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Container(
          margin: const EdgeInsets.only(top: 50.0,),
          child:  Image.asset(
              'lib/assets/icono.png',
              height: 100,
              width: 100,
            ), 
            ),
          Container(
          margin: const EdgeInsets.only(top: 30.0),
          child: const Text("Registro", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white,),), 
          ), 
        Container(
        width: 300, // Ajusta el ancho
        height: 60, // Ajusta la altura
        margin: const EdgeInsets.only(top: 40.0), // Margen externo
        child: TextFormField(
          controller: nombreController,
          decoration: InputDecoration(
            labelText: 'Nombre',
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
          controller: edadController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Edad',            
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
                  'Sexo', // Etiqueta que aparece fuera del campo
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
                  'Especie', // Etiqueta que aparece fuera del campo
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
          controller: razaController,
          decoration: InputDecoration(
            labelText: 'Raza',                       
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
                  'Color', // Etiqueta que aparece fuera del campo
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
          controller: pesoController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Peso',            
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
          controller: correoController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo',            
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
          controller: usuarioController,
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
        width: 300, // Ajusta el ancho
        height: 60, // Ajusta la altura
        margin: const EdgeInsets.only(top: 40.0), // Margen externo
        child: TextFormField(
          controller: passwordController,
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Contraseña',            
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
            margin: const EdgeInsets.only(top: 40.0, bottom: 40),
            child: ElevatedButton(onPressed: () => _registrar(context),
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: const Color(0xFF00B2FF),
                minimumSize: const Size(150, 50)
            ),
            child: const Text('Registrar',  style: TextStyle(fontSize: 22.0),), 
            ),
          )
        ],
      ),
      )
      )
      )
    );
  }
}
