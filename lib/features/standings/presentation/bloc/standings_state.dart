import 'package:equatable/equatable.dart';
import 'package:liga_app/features/standings/domain/entities/team_standing.dart';

sealed class StandingsState extends Equatable {
  const StandingsState();
  @override
  List<Object?> get props => [];
}

/// Todavía no se ha pedido nada
final class StandingsInitial extends StandingsState {
  const StandingsInitial();
}

/// Esperando la respuesta de la API
final class StandingsLoading extends StandingsState {
  const StandingsLoading();
}

final class StandingsLoaded extends StandingsState {
  const StandingsLoaded(this.standings);
  final List<TeamStanding> standings;
  @override
  List<Object?> get props => [standings];
}

final class StandingsError extends StandingsState {
  final String message;
  const StandingsError(this.message);
  @override
  List<Object?> get props => [message];
}
