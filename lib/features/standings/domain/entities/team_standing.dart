import 'package:equatable/equatable.dart';

class TeamStanding extends Equatable {
  const TeamStanding({
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

  @override
  List<Object?> get props => [teamId, position, points];
}