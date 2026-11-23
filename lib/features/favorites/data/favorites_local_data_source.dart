import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import 'favorite_team.dart';

class FavoritesLocalDataSource {
  const FavoritesLocalDataSource(this._database);

  final AppDatabase _database;

  Database get _db => _database.db;

  /// Leer todos los favoritos, ordenados por nombre
  Future<List<FavoriteTeam>> getAll() async {
    final rows = await _db.query(
      AppDatabase.favoritesTable,
      orderBy: 'name ASC',
    );
    return rows.map(FavoriteTeam.fromMap).toList();
  }

  /// Guardar un favorito (si ya existe, lo reemplaza)
  Future<void> add(FavoriteTeam team) async {
    await _db.insert(
      AppDatabase.favoritesTable,
      team.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Borrar un favorito por su id
  Future<void> remove(int teamId) async {
    await _db.delete(
      AppDatabase.favoritesTable,
      where: 'team_id = ?',
      whereArgs: [teamId],
    );
  }
}
