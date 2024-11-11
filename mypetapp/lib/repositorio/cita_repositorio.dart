import '../modelos/cita_modelo.dart';
import '../db/db_helper.dart';

class CitaRepositorio {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> agregarCita(Cita cita) async {
    final db = await _dbHelper.database;
    return await db.insert('citas', cita.toMap());
  }

  Future<List<Cita>> obtenerCitasPorUsuario(int idUsuario) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'citas',
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
    );
    return result.map((map) => Cita.fromMap(map)).toList();
  }

  Future<int> actualizarCita(Cita cita) async {
    final db = await _dbHelper.database;
    return await db.update(
      'citas',
      cita.toMap(),
      where: 'idCita = ?',
      whereArgs: [cita.idCita],
    );
  }

  Future<int> eliminarCita(int idCita) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'citas',
      where: 'idCita = ?',
      whereArgs: [idCita],
    );
  }
}
