import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final _dbName = 'favorites.db';
  static final _tableName = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY,
            productId INTEGER
          )
        ''');
      },
    );
  }

  Future<void> addToFavorites(int productId) async {
    final db = await database;
    await db.insert(_tableName, {'productId': productId});
  }

  Future<void> removeFromFavorites(int productId) async {
    final db = await database;
    await db.delete(_tableName, where: 'productId = ?', whereArgs: [productId]);
  }

  Future<List<int>> getFavoriteProductIds() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return maps[i]['productId'] as int;
    });
  }
}
