import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedor/cita_proveedor.dart';
import 'editar_cita.dart';

class CitasScreen extends StatelessWidget {
  const CitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final citaProveedor = Provider.of<CitaProveedor>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Citas Veterinarias')),
      body: FutureBuilder(
        future: citaProveedor.cargarCitasUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<CitaProveedor>(
              builder: (context, citaData, child) {
                return ListView.builder(
                  itemCount: citaData.citas.length,
                  itemBuilder: (context, index) {
                    final cita = citaData.citas[index];
                    return ListTile(
                      title: Text('Tipo: ${cita.tipo}'),
                      subtitle: Text('Fecha: ${cita.fecha}, Hora: ${cita.hora}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditarCitaScreen(cita: cita),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (cita.idCita != null) {
                                await citaData.eliminarCita(cita.idCita!); // Usamos el operador '!' para asegurarnos de que no es nulo
                              } else {
                                // Manejo de error si el idCita es nulo
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("El ID de la cita no es válido."),
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
