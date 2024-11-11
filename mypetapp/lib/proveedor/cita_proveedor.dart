import 'package:flutter/material.dart';
import '../modelos/cita_modelo.dart';
import '../repositorio/cita_repositorio.dart';
import '../utils/session_manager.dart';

class CitaProveedor with ChangeNotifier {
  final CitaRepositorio _citaRepositorio = CitaRepositorio();
  List<Cita> _citas = [];

  List<Cita> get citas => _citas;

  // Cargar citas del usuario actual
  Future<void> cargarCitasUsuario() async {
    final idUsuario = await SessionManager.getUserId();
    if (idUsuario != null) {
      _citas = await _citaRepositorio.obtenerCitasPorUsuario(int.parse(idUsuario));
      notifyListeners();
    }
  }

  // Agregar una nueva cita para el usuario actual
  Future<void> agregarCita(Cita cita) async {
    final idUsuario = await SessionManager.getUserId();
    if (idUsuario != null) {
      cita = Cita(
        fecha: cita.fecha,
        hora: cita.hora,
        tipo: cita.tipo,
        idUsuario: int.parse(idUsuario),
      );
      await _citaRepositorio.agregarCita(cita);
      // ignore: avoid_print
      print("Guardando cita: ${cita.fecha}, ${cita.hora}, ${cita.tipo}");
      await cargarCitasUsuario();
    }
  }

  // Actualizar una cita existente
  Future<void> actualizarCita(Cita cita) async {
    await _citaRepositorio.actualizarCita(cita);
    await cargarCitasUsuario();
  }

  // Eliminar una cita existente
  Future<void> eliminarCita(int idCita) async {
    await _citaRepositorio.eliminarCita(idCita);
    await cargarCitasUsuario();
  }
}
