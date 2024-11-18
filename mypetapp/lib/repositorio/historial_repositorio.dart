import '../modelos/historial_modelo.dart';
import '../db/db_helper.dart';

class HistorialRepositorio {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> agregarHistorial(Historial historial) async {
    final db = await _dbHelper.database;
    return await db.insert('historial', historial.toMap());
  }

  Future<List<Historial>> obtenerHistorialPorUsuario(int idUsuario) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'historial',
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
    );
    return result.map((map) => Historial.fromMap(map)).toList();
  }

  Future<int> actualizarHistorial(Historial historial) async {
    final db = await _dbHelper.database;
    return await db.update(
      'historial',
      historial.toMap(),
      where: 'idHistorial = ?',
      whereArgs: [historial.idHistorial],
    );
  }

  Future<int> eliminarHistorial(int idHistorial) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'historial',
      where: 'idHistorial = ?',
      whereArgs: [idHistorial],
    );
  }
}