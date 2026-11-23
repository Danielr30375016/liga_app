import 'package:dio/dio.dart';
import 'package:liga_app/features/standings/data/models/standing_model.dart';

abstract interface class StandingsRemoteDataSource {
  Future<List<StandingModel>> fetchStandings(String competition);
}

class StandingsRemoteDataSourceImpl implements StandingsRemoteDataSource {
  StandingsRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<StandingModel>> fetchStandings(String competition) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'competitions/$competition/standings',
    );
    final standings = response.data!['standings'] as List<dynamic>;
    // La API trae varias tablas (TOTAL, HOME, AWAY). Usamos la general.
    final total = standings.firstWhere(
      (s) => (s as Map<String, dynamic>)['type'] == 'TOTAL',
    ) as Map<String, dynamic>;
    final table = total['table'] as List<dynamic>;

    return table
        .map((row) => StandingModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
