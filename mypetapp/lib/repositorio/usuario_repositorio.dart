import 'package:bcrypt/bcrypt.dart';
import '../db/db_helper.dart';
import '../modelos/usuario_modelo.dart';

class UsuarioRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> registrarUsuario(Usuario usuario) async {
    final db = await _dbHelper.database;

    // Verificar si el usuario ya existe
    final List<Map<String, dynamic>> existingUsers = await db.query(
      'usuario',
      where: 'usuario = ?',
      whereArgs: [usuario.usuario],
    );

    if (existingUsers.isNotEmpty) {
      return false; // Usuario ya existe
    }

    // Cifrar la contraseña
    String hashedPassword = BCrypt.hashpw(usuario.password, BCrypt.gensalt());

    // Insertar el nuevo usuario
    await db.insert('usuario', {
      'nombre': usuario.nombre,
      'edad': usuario.edad,
      'especie': usuario.especie,
      'raza': usuario.raza,
      'color': usuario.color,
      'peso': usuario.peso,
      'correo': usuario.correo,
      'usuario': usuario.usuario,
      'password': hashedPassword,
    });

    return true;
  }

  Future<String?> iniciarSesion(String usuario, String password) async {
  final db = await _dbHelper.database;

  final List<Map<String, dynamic>> users = await db.query(
    'usuario',
    where: 'usuario = ?',
    whereArgs: [usuario],
  );

  if (users.isNotEmpty) {
    String hashedPassword = users[0]['password'];
    if (BCrypt.checkpw(password, hashedPassword)) {
      return users[0]['idUsuario'].toString(); // Devuelve el ID del usuario como String
    }
  }
  return null; // Devuelve null si el usuario no existe o la contraseña es incorrecta
  }

  Future<Usuario?> obtenerPerfil(String idUsuario) async {
  final db = await _dbHelper.database;
  
  // Consulta el perfil del usuario por ID
  final List<Map<String, dynamic>> maps = await db.query(
    'usuario',
    where: 'idUsuario = ?',
    whereArgs: [idUsuario],
  );

  if (maps.isNotEmpty) {
    return Usuario.fromMap(maps.first); // Retorna el usuario encontrado
  }
  return null; // Retorna null si no encuentra el usuario
  }

  Future<bool> actualizarPerfil(Usuario usuario) async {
  final db = await _dbHelper.database;

  // Actualiza el perfil del usuario en la base de datos
  int rowsAffected = await db.update(
    'usuario',
    usuario.toMap(),
    where: 'idUsuario = ?',
    whereArgs: [usuario.idUsuario],
  );

  return rowsAffected > 0; // Retorna true si se actualizó correctamente
  }

}
