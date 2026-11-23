import 'package:liga_app/features/standings/domain/entities/team_standing.dart';

abstract class StandingsRepository {
  Future<List<TeamStanding>> getStandings({String competition = 'PD'});
}
