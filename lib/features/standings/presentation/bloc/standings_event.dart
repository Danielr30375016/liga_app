import 'package:equatable/equatable.dart';

sealed class StandingsEvent extends Equatable {
  const StandingsEvent();
  @override
  List<Object?> get props => [];
}

/// La pantalla se abrió o el usuario tocó "Reintentar"
final class StandingsRequested extends StandingsEvent {
  const StandingsRequested();
}

/// El usuario eligió otra liga (PD = LaLiga, PL = Premier League)
final class CompetitionChanged extends StandingsEvent {
  const CompetitionChanged(this.competition);
  final String competition;
  @override
  List<Object?> get props => [competition];
}
