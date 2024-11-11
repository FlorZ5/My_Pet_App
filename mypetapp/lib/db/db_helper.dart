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
    String path = join(await getDatabasesPath(), 'mypetapp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _crearTablas,
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    // Creación de la tabla usuario
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS usuario (
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

    // Creación de la tabla citas
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS citas (
        idCita INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT,
        hora TEXT,
        tipo TEXT,
        idUsuario INTEGER,
        FOREIGN KEY (idUsuario) REFERENCES usuario (idUsuario)
      )
      '''
    );
  }
}