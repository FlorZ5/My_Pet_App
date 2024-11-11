import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _idUsuarioKey = 'idUsuario'; // Renombramos la clave para que coincida con tu modelo

  // Guarda el ID del usuario en las preferencias compartidas
  static Future<void> saveUserId(String idUsuario) async {  // Renombramos el parámetro a idUsuario
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idUsuarioKey, idUsuario);  // Usamos _idUsuarioKey en lugar de _userIdKey
  }

  // Obtiene el ID del usuario desde las preferencias compartidas
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idUsuarioKey);  // Usamos _idUsuarioKey en lugar de _userIdKey
  }

  // Elimina el ID del usuario para cerrar la sesión
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idUsuarioKey);  // Usamos _idUsuarioKey en lugar de _userIdKey
  }
}

