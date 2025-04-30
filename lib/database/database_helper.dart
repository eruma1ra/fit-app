import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

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
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activity_type TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        distance TEXT NOT NULL,
        time TEXT NOT NULL,
        coordinates TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE activities ADD COLUMN distance TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE activities ADD COLUMN time TEXT');
    }
  }

  Future<int> insertActivity(Map<String, dynamic> activity) async {
    final db = await database;
    return await db.insert('activities', activity);
  }

  Future<List<Map<String, dynamic>>> getActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activities',
      orderBy: 'start_time DESC',
    );

    return maps.map((map) {
      try {
        final coordinates = jsonDecode(map['coordinates'] ?? '[]');
        return {...map, 'coordinates': coordinates};
      } catch (e) {
        return {...map, 'coordinates': []};
      }
    }).toList();
  }

  Future<int> deleteActivity(int id) async {
    try {
      final db = await database;
      return await db.delete('activities', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting activity: $e');
      return 0;
    }
  }

  Future<int> updateActivity(Map<String, dynamic> activity) async {
    final db = await database;
    // Сериализация координат в JSON перед сохранением
    final coordinatesJson = jsonEncode(activity['coordinates'] ?? []);

    return await db.update(
      'activities',
      {
        'activity_type': activity['activity_type'],
        'start_time': activity['start_time'],
        'end_time': activity['end_time'],
        'distance': activity['distance'],
        'time': activity['time'],
        'coordinates': coordinatesJson,
      },
      where: 'id = ?',
      whereArgs: [activity['id']],
    );
  }
}
