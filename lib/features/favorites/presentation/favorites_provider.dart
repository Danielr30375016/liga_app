import 'package:flutter/foundation.dart';

import '../data/favorite_team.dart';
import '../data/favorites_local_data_source.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._dataSource);

  final FavoritesLocalDataSource _dataSource;

  List<FavoriteTeam> _favorites = [];
  bool _isLoading = false;

  /// Lista de sólo lectura: desde afuera nadie puede modificarla directamente
  List<FavoriteTeam> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;

  bool isFavorite(int teamId) => _favorites.any((f) => f.teamId == teamId);

  /// Carga los favoritos guardados en SQLite
  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _favorites = await _dataSource.getAll();

    _isLoading = false;
    notifyListeners();
  }

  /// Si es favorito lo quita; si no, lo agrega
  Future<void> toggle(FavoriteTeam team) async {
    if (isFavorite(team.teamId)) {
      await _dataSource.remove(team.teamId);
    } else {
      await _dataSource.add(team);
    }
    _favorites = await _dataSource.getAll();
    notifyListeners();
  }
}
