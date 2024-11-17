import 'package:flutter/material.dart';
import '../modelos/vacunas_modelo.dart';
import '../repositorio/vacuna_repositorio.dart';
import '../utils/session_manager.dart';

class VacunaProveedor with ChangeNotifier {
  final VacunaRepositorio _vacunaRepositorio = VacunaRepositorio();
  List<Vacuna> _vacunas = [];

  List<Vacuna> get vacunas => _vacunas;

  // Cargar citas del usuario actual
  Future<void> cargarVacunasUsuario() async {
    final idUsuario = await SessionManager.getUserId();
    if (idUsuario != null) {
      _vacunas = await _vacunaRepositorio.obtenerVacunasPorUsuario(int.parse(idUsuario));
      notifyListeners();
    }
  }

  // Agregar una nueva cita para el usuario actual
  Future<void> agregarVacuna(Vacuna vacuna) async {
    final idUsuario = await SessionManager.getUserId();
    if (idUsuario != null) {
      vacuna = Vacuna(
        nombre: vacuna.nombre,
        dosis: vacuna.dosis,
        marca: vacuna.marca,
        fecha: vacuna.fecha,
        idUsuario: int.parse(idUsuario),
      );
      await _vacunaRepositorio.agregarVacuna(vacuna);
      // ignore: avoid_print
      print("Guardando vacuna: ${vacuna.nombre}, ${vacuna.dosis}, ${vacuna.marca}, ${vacuna.fecha}");
      await cargarVacunasUsuario();
    }
  }

  // Actualizar una cita existente
  Future<void> actualizarVacuna(Vacuna vacuna) async {
    await _vacunaRepositorio.actualizarVacuna(vacuna);
    await cargarVacunasUsuario();
  }

  // Eliminar una cita existente
  Future<void> eliminarVacuna(int idVacuna) async {
    await _vacunaRepositorio.eliminarVacuna(idVacuna);
    await cargarVacunasUsuario();
  }
}
