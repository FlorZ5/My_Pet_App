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
      return users[0]['id'].toString(); // Devuelve el ID del usuario como String
    }
  }
  return null; // Devuelve null si el usuario no existe o la contraseña es incorrecta
}
}


/*class UsuarioRepositorio {
  final AyudanteBaseDatos _ayudanteBaseDatos = AyudanteBaseDatos();
  
  Future <List<Usuario>> obtenerTodosLosUsuarios() async {
    return await _ayudanteBaseDatos.obtenerUsuarios();
  }

  Future <void> agregarUsuario(Usuario usuario) async {
    await _ayudanteBaseDatos.insertarUsuario(usuario);
  }

  Future <void> actualizarUsuario(Usuario usuario) async {
    await _ayudanteBaseDatos.actualizarUsuario(usuario);
  }

  Future <void> eliminarUsuario(int idUsuario) async {
    await _ayudanteBaseDatos.eliminarUsuario(idUsuario);
  }
}*/