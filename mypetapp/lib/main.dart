import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/login_screen.dart';
import 'proveedor/cita_proveedor.dart';
import 'proveedor/vacuna_proveedor.dart';
import 'proveedor/historial_proveedor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MultiProvider(
      providers: [
        ChangeNotifierProvider<CitaProveedor>(create: (_) => CitaProveedor()),
        ChangeNotifierProvider<VacunaProveedor>(create: (_) => VacunaProveedor()),
        ChangeNotifierProvider<HistorialProveedor>(create: (_) => HistorialProveedor()),
      ],
    child: MaterialApp(
      title: 'My pet app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    )
    );
  }
}
