import 'package:dio/dio.dart';
import 'package:liga_app/core/error/failure.dart';
import 'package:liga_app/features/standings/data/datasources/standings_remote_data_source.dart';
import 'package:liga_app/features/standings/domain/entities/team_standing.dart';
import 'package:liga_app/features/standings/domain/repositories/standings_repository.dart';

class StandingsRepositoryImpl implements StandingsRepository {
  const StandingsRepositoryImpl(this._remote);
  final StandingsRemoteDataSource _remote;
  @override
  Future<List<TeamStanding>> getStandings({String competition = 'PD'}) async {
    try {
      final models = await _remote.fetchStandings(competition);
      return models.map((model) => model.toEntity()).toList();
    } on Exception catch (e) {
      throw Failure(_messageFor(e as DioException));
    }
  }

  String _messageFor(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout || DioExceptionType.receiveTimeout =>
        'El servidor tardó demasiado en responder.',
      DioExceptionType.connectionError =>
        'Sin conexión. Revisa tu internet (o que el proxy esté encendido).',
      DioExceptionType.badResponse => switch (e.response?.statusCode) {
        429 => 'Demasiadas consultas. Espera un minuto e intenta de nuevo.',
        401 || 403 => 'La API key no es válida.',
        _ => 'Error del servidor (${e.response?.statusCode}).',
      },
      _ => 'Ocurrió un error inesperado.',
    };
  }
}
