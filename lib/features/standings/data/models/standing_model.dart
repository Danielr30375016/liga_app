import '../../domain/entities/team_standing.dart';

class StandingModel {
  const StandingModel({
    required this.position,
    required this.teamId,
    required this.teamName,
    required this.shortName,
    required this.crestUrl,
    required this.playedGames,
    required this.won,
    required this.draw,
    required this.lost,
    required this.points,
    required this.goalDifference,
  });

  final int position;
  final int teamId;
  final String teamName;
  final String shortName;
  final String crestUrl;
  final int playedGames;
  final int won;
  final int draw;
  final int lost;
  final int points;
  final int goalDifference;

  factory StandingModel.fromJson(Map<String, dynamic> json) {
    final team = json['team'] as Map<String, dynamic>;
    return StandingModel(
      position: json['position'] as int,
      teamId: team['id'] as int,
      teamName: team['name'] as String,
      shortName: (team['shortName'] ?? team['name']) as String,
      crestUrl: (team['crest'] ?? '') as String,
      playedGames: json['playedGames'] as int,
      won: json['won'] as int,
      draw: json['draw'] as int,
      lost: json['lost'] as int,
      points: json['points'] as int,
      goalDifference: json['goalDifference'] as int,
    );
  }

  TeamStanding toEntity() => TeamStanding(
    position: position,
    teamId: teamId,
    teamName: teamName,
    shortName: shortName,
    crestUrl: crestUrl,
    playedGames: playedGames,
    won: won,
    draw: draw,
    lost: lost,
    points: points,
    goalDifference: goalDifference,
  );
}
