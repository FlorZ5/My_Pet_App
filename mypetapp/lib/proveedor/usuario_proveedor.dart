import '../modelos/usuario_modelo.dart';
import '../repositorio/usuario_repositorio.dart';

class UsuarioProvider {
  final UsuarioRepository _repository = UsuarioRepository();

  Future<bool> registrarUsuario(Usuario usuario) {
    return _repository.registrarUsuario(usuario);
  }

  // Cambiar el método para que devuelva un String?
  Future<String?> iniciarSesion(String usuario, String password) {
    return _repository.iniciarSesion(usuario, password);
  }
}

/*class UsuarioProvider with ChangeNotifier {
  final UsuarioRepositorio _usuarioRepositorio = UsuarioRepositorio();
  List <Usuario> _usuarios = [];

  List<Usuario> get usuarios => _usuarios;

  Future <void> obtenerUsuarios() async{
    _usuarios = await _usuarioRepositorio.obtenerTodosLosUsuarios();
    notifyListeners();
  }

  Future <void> agregarUsuario(Usuario usuario) async{
    await _usuarioRepositorio.agregarUsuario(usuario);
    await obtenerUsuarios();
  }

  Future <void> actualizarUsuario(Usuario usuario) async{
    await _usuarioRepositorio.actualizarUsuario(usuario);
    await obtenerUsuarios();
  }

  Future <void> eliminarUsuario(int idUsuario) async{
    await _usuarioRepositorio.eliminarUsuario(idUsuario);
    await obtenerUsuarios();
  }
  
}*/