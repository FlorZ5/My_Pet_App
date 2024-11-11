import 'package:flutter/material.dart';
import '../proveedor/usuario_proveedor.dart';
import 'inicio_screen.dart';
import '../utils/session_manager.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final UsuarioProvider _usuarioProvider = UsuarioProvider();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> _iniciarSesion(BuildContext context) async {
  if (usuarioController.text.isEmpty || passwordController.text.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor, ingresa usuario y contraseña.'),
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
    return;
  }
  
  String? idUsuario = await _usuarioProvider.iniciarSesion(
    usuarioController.text,
    passwordController.text,
  );

  if (idUsuario != null) {
    // Guardar el ID del usuario en la sesión
    await SessionManager.saveUserId(idUsuario);

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inicio de sesión exitoso'),
          content: const Text('¡Bienvenido! Has iniciado sesión correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PaginaInicio()),
                );
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de inicio de sesión'),
          content: const Text('Usuario o contraseña incorrectos.'),
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
      backgroundColor: Colors.black,
       resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center( 
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
          margin: const EdgeInsets.only(top: 80.0, bottom: 20.0),
          child:  Image.asset(
              'lib/assets/icono.png', // Cambia a la ruta de tu imagen
              height: 150,
              width: 150,
            ), 
            ),                       
          Container(
          margin: const EdgeInsets.only(top: 30.0, bottom: 20.0),
          child: const Text("Inicio de sesión", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white,),), 
          ),           
        Container(
        width: 300, // Ajusta el ancho
        height: 60, // Ajusta la altura
        margin: const EdgeInsets.only(top: 40.0), // Margen externo
        child: TextField(
          controller: usuarioController,
          decoration: InputDecoration(
            labelText: 'Usuario',
            labelStyle: const TextStyle(fontSize: 18.0,), // Cambiar tamaño de letra
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
        height: 60,
        margin: const EdgeInsets.only(top: 40.0), // Margen externo
        child: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: const TextStyle(fontSize: 18.0), // Cambiar tamaño de letra
            floatingLabelBehavior: FloatingLabelBehavior.never,
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
          margin: const EdgeInsets.only(top: 40.0,),
          child: ElevatedButton(
            onPressed: () => _iniciarSesion(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: const Color(0xFF00B2FF),
              minimumSize: const Size(150, 50)
            ),
            child: const Text('Iniciar sesión', style: TextStyle(fontSize: 22.0),),
          ),
          ),
          Container(
          margin: const EdgeInsets.only(top: 60.0,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("¿No tienes cuenta? ", style: TextStyle(fontSize: 20.0, color: Colors.white,),),
              GestureDetector(
                onTap: () {
                  // Navegar a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text(
                  "Regístrate aquí",
                  style: TextStyle(
                    color: Colors.blue,
                    //decoration: TextDecoration.underline,
                    fontSize: 20.0
                  ),
                ),
              ),
            ],
          ),          
        ),
        ],
      ),
    )
    )
    )
    );
  }
}
