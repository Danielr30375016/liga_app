import 'package:flutter/material.dart';
import 'package:liga_app/features/standings/presentation/widgets/standings_tile.dart';

import '../../domain/entities/team_standing.dart';

class TeamDetailPage extends StatelessWidget {
  const TeamDetailPage({super.key, required this.team});

  final TeamStanding? team;

  @override
  Widget build(BuildContext context) {
    final team = this.team;

    return Scaffold(
      appBar: AppBar(title: Text(team?.shortName ?? 'Equipo')),
      body: team == null
          ? const Center(child: Text('Equipo no encontrado. Vuelve a la tabla.'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(child: TeamCrest(url: team.crestUrl, size: 96)),
                const SizedBox(height: 16),
                Text(
                  team.teamName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                _StatRow(label: 'Posición', value: '${team.position}°'),
                _StatRow(label: 'Puntos', value: '${team.points}'),
                _StatRow(label: 'Partidos jugados', value: '${team.playedGames}'),
                _StatRow(label: 'Ganados', value: '${team.won}'),
                _StatRow(label: 'Empatados', value: '${team.draw}'),
                _StatRow(label: 'Perdidos', value: '${team.lost}'),
                _StatRow(label: 'Diferencia de gol', value: '${team.goalDifference}'),
              ],
            ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}