import '../modelos/usuario_modelo.dart';
import '../repositorio/usuario_repositorio.dart';

class UsuarioProvider{
  final UsuarioRepository _repository = UsuarioRepository();

  Future<bool> registrarUsuario(Usuario usuario) {
    return _repository.registrarUsuario(usuario);
  }

  // Cambiar el método para que devuelva un String?
  Future<String?> iniciarSesion(String usuario, String password) {
    return _repository.iniciarSesion(usuario, password);
  }

  Future<Usuario?> obtenerPerfil(String idUsuario) async {
  return await _repository.obtenerPerfil(idUsuario);
  }

  Future<bool> actualizarPerfil(Usuario usuario) async {
  return await _repository.actualizarPerfil(usuario);
  }
}
