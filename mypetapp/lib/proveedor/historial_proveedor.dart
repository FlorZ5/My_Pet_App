import 'package:flutter/material.dart';
import '../modelos/historial_modelo.dart';
import '../repositorio/historial_repositorio.dart';
import '../utils/session_manager.dart';

class HistorialProveedor with ChangeNotifier {
  final HistorialRepositorio _historialRepositorio = HistorialRepositorio();
  List<Historial> _historial = [];

  List<Historial> get historial => _historial;

  // Cargar historial del usuario actual
  Future<void> cargarHistorialUsuario() async {
    final idUsuario = await SessionManager.getUserId();
    if (idUsuario != null) {
      _historial = await _historialRepositorio.obtenerHistorialPorUsuario(int.parse(idUsuario));
      notifyListeners();
    }
  }

  // Agregar una nuevo historial para el usuario actual
  Future<void> agregarHistorial(Historial historial) async {
    final idUsuario = await SessionManager.getUserId();
    if (idUsuario != null) {
      historial = Historial(
        enfermedad: historial.enfermedad,
        tratamiento: historial.tratamiento,
        estadoTratamiento: historial.estadoTratamiento,
        idUsuario: int.parse(idUsuario),
      );
      await _historialRepositorio.agregarHistorial(historial);
      // ignore: avoid_print
      print("Guardando historial: ${historial.enfermedad}, ${historial.tratamiento}, ${historial.estadoTratamiento}");
      await cargarHistorialUsuario();
    }
  }

  // Actualizar un historial existente
  Future<void> actualizarHistorial(Historial historial) async {
    await _historialRepositorio.actualizarHistorial(historial);
    await cargarHistorialUsuario();
  }

  // Eliminar un historial existente
  Future<void> eliminarHistorial(int idHistorial) async {
    await _historialRepositorio.eliminarHistorial(idHistorial);
    await cargarHistorialUsuario();
  }
}