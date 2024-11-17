import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedor/vacuna_proveedor.dart';
import 'editar_vacuna.dart';

class VacunasScreen extends StatelessWidget {
  const VacunasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vacunaProveedor = Provider.of<VacunaProveedor>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Vacunas')),
      body: FutureBuilder(
        future: vacunaProveedor.cargarVacunasUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<VacunaProveedor>(
              builder: (context, vacunaData, child) {
                return ListView.builder(
                  itemCount: vacunaData.vacunas.length,
                  itemBuilder: (context, index) {
                    final vacuna = vacunaData.vacunas[index];
                    return ListTile(
                      title: Text('Nombre: ${vacuna.nombre}'),
                      subtitle: Text('Dosis: ${vacuna.dosis}, Marca: ${vacuna.marca}, Fecha: ${vacuna.fecha}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditarVacunaScreen(vacuna: vacuna),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (vacuna.idVacuna != null) {
                                await vacunaData.eliminarVacuna(vacuna.idVacuna!); // Usamos el operador '!' para asegurarnos de que no es nulo
                              } else {
                                // Manejo de error si el idCita es nulo
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("El ID de la vacuna no es válido."),
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