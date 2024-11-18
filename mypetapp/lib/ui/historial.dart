import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedor/historial_proveedor.dart';
import 'editar_historial.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historialProveedor = Provider.of<HistorialProveedor>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: FutureBuilder(
        future: historialProveedor.cargarHistorialUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<HistorialProveedor>(
              builder: (context, historialData, child) {
                return ListView.builder(
                  itemCount: historialData.historial.length,
                  itemBuilder: (context, index) {
                    final historial = historialData.historial[index];
                    return ListTile(
                      title: Text('Enfermedad: ${historial.enfermedad}'),
                      subtitle: Text('Tratamiento: ${historial.tratamiento}, Estado del tratamiento: ${historial.estadoTratamiento},'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditarHistorialScreen(historial: historial),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (historial.idHistorial != null) {
                                await historialData.eliminarHistorial(historial.idHistorial!); // Usamos el operador '!' para asegurarnos de que no es nulo
                              } else {
                                // Manejo de error si el idCita es nulo
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("El ID del historial no es válido."),
                                ));
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}