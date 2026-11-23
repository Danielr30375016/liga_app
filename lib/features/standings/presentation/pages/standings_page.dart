import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:liga_app/features/standings/presentation/widgets/standings_tile.dart';

import '../../../../core/di/injection.dart';
import '../bloc/standings_bloc.dart';
import '../bloc/standings_event.dart';
import '../bloc/standings_state.dart';

class StandingsPage extends StatelessWidget {
  const StandingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StandingsBloc>()..add(const StandingsRequested()),
      child: const _StandingsView(),
    );
  }
}

class _StandingsView extends StatelessWidget {
  const _StandingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liga App'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: 'Cambiar liga',
            onSelected: (code) =>
                context.read<StandingsBloc>().add(CompetitionChanged(code)),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'PD', child: Text('LaLiga')),
              PopupMenuItem(value: 'PL', child: Text('Premier League')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<StandingsBloc, StandingsState>(
        builder: (context, state) => switch (state) {
          StandingsInitial() || StandingsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          StandingsError(:final message) => _ErrorView(
            message: message,
            onRetry: () =>
                context.read<StandingsBloc>().add(const StandingsRequested()),
          ),
          StandingsLoaded(:final standings) => RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<StandingsBloc>()
                ..add(const StandingsRequested());
              await bloc.stream.firstWhere((s) => s is! StandingsLoading);
            },
            child: ListView.separated(
              itemCount: standings.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final team = standings[index];
                return StandingTile(
                  standing: team,
                  onTap: () => context.go('/team/${team.teamId}', extra: team),
                );
              },
            ),
          ),
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
