import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _crearTablas,
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE usuario(
        idUsuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        edad INTEGER NOT NULL CHECK(edad >= 0),
        especie TEXT NOT NULL,
        raza TEXT NOT NULL,
        color TEXT NOT NULL,
        peso REAL NOT NULL,
        correo TEXT NOT NULL,
        usuario TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
      '''
    );
  }
}

/*class AyudanteBaseDatos{
  static final AyudanteBaseDatos _instancia = AyudanteBaseDatos._interno();
  static Database? _baseDatos;
  
  factory AyudanteBaseDatos()=> _instancia;

  AyudanteBaseDatos._interno();

  Future<Database> get baseDatos async{
    if (_baseDatos !=null) return _baseDatos!;
    _baseDatos = await _inicializarBaseDatos();
    return _baseDatos!;
  }

  Future <Database> _inicializarBaseDatos() async {
    String ruta = join(await getDatabasesPath(), 'mypetapp.db');
    return await openDatabase(
      ruta,
      version: 1, 
      onCreate: _crearTablas,
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute(
      '''
          CREATE TABLE usuario(
          idUusario INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          edad INTEGER NOT NULL,
          especie TEXT NOT NULL,
          raza TEXT NOT NULL,
          color TEXT NOT NULL,
          peso REAL NOT NULL,
          correo TEXT NOT NULL,
          usuario TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL UNIQUE
          )
      '''
    );
  }

  Future <int> insertarUsuario(Usuario usuario) async {
    final db = await baseDatos;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future <List<Usuario>>  obtenerUsuarios() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query('usuarios');
    return List.generate(mapas.length, (i)=>Usuario.fromMap(mapas[i]));
  }

  Future <int> actualizarUsuario(Usuario usuario) async {
    final db = await baseDatos;
    return await db.update(
      'usuarios',
      usuario.toMap(),
      where:' idUsuario= ?',
      whereArgs: [usuario.idUsuario]
    );
  }

  Future <int> eliminarUsuario(int idUsuario) async {
    final db = await baseDatos;
    return await db.delete(
      'usuarios',
      where: 'idUsuario= ?',
      whereArgs: [idUsuario],
    );
  }
}*/