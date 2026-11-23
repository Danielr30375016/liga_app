import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_factory.dart';

class AppDatabase {
  AppDatabase._(this.db); // privado: sólo se crea con open()

  final Database db;

  static const _dbName = 'liga.db';
  static const favoritesTable = 'favorites';

  static Future<AppDatabase> open() async {
    final factory = appDatabaseFactory;
    final path = kIsWeb
        ? _dbName
        : join(await factory.getDatabasesPath(), _dbName);

    final db = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $favoritesTable (
              team_id   INTEGER PRIMARY KEY,
              name      TEXT NOT NULL,
              crest_url TEXT NOT NULL
            )
          ''');
        },
      ),
    );

    return AppDatabase._(db);
  }
}
