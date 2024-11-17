import '../modelos/vacunas_modelo.dart';
import '../db/db_helper.dart';

class VacunaRepositorio {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> agregarVacuna(Vacuna vacuna) async {
    final db = await _dbHelper.database;
    return await db.insert('vacunas', vacuna.toMap());
  }

  Future<List<Vacuna>> obtenerVacunasPorUsuario(int idUsuario) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'vacunas',
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
    );
    return result.map((map) => Vacuna.fromMap(map)).toList();
  }

  Future<int> actualizarVacuna(Vacuna vacuna) async {
    final db = await _dbHelper.database;
    return await db.update(
      'vacunas',
      vacuna.toMap(),
      where: 'idVacuna = ?',
      whereArgs: [vacuna.idVacuna],
    );
  }

  Future<int> eliminarVacuna(int idVacuna) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'vacunas',
      where: 'idVacuna = ?',
      whereArgs: [idVacuna],
    );
  }
}