import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal() {
    // Inicializar el factory para FFI (necesario para Windows/Desktop)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'diary.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            content TEXT,
            emotion TEXT,
            tags TEXT
          )
        ''');
      },
    );
  }

  // Insertar nueva entrada
  Future<int> insertEntry(Map<String, dynamic> entry) async {
    final db = await database;
    return await db.insert('entries', entry);
  }

  // Obtener todas las entradas
  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await database;
    return await db.query('entries', orderBy: "date DESC");
  }

  // Buscar por palabra
  Future<List<Map<String, dynamic>>> searchEntries(String keyword) async {
    final db = await database;
    return await db.query(
      'entries',
      where: "content LIKE ? OR tags LIKE ?",
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
  }

  // Eliminar entrada
  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete('entries', where: "id = ?", whereArgs: [id]);
  }

  // Cerrar la base de datos (opcional pero recomendado)
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}