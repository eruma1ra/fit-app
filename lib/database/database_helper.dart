import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert'; // Для работы с JSON

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_bd.sqlite3');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activity_type TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        coordinates TEXT
      )
    ''');
  }

  // Вставка активности в базу данных
  Future<void> insertActivity(Map<String, dynamic> activity) async {
    final db = await database;

    // Сериализация координат в JSON
    final coordinatesJson = jsonEncode(activity['coordinates']);

    await db.insert('activities', {
      'activity_type': activity['activity_type'],
      'start_time': activity['start_time'],
      'end_time': activity['end_time'],
      'coordinates': coordinatesJson,
    });
  }

  // Получение всех активностей из базы данных
  Future<List<Map<String, dynamic>>> getActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('activities');

    return maps.map((map) {
      // Десериализация координат
      final coordinates = jsonDecode(map['coordinates']);
      return {...map, 'coordinates': coordinates};
    }).toList();
  }
}
