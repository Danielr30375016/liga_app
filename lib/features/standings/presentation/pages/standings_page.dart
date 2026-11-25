import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:liga_app/core/platform/share_services.dart';
import 'package:liga_app/core/widgets/connection_indicator.dart';
import 'package:liga_app/features/standings/presentation/widgets/standings_tile.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../favorites/data/favorite_team.dart';
import '../../../favorites/presentation/favorites_provider.dart';
import '../../domain/entities/team_standing.dart';
import '../bloc/standings_bloc.dart';
import '../bloc/standings_event.dart';
import '../bloc/standings_state.dart';
import 'team_detail_page.dart';

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
          const ConnectionIndicator(), // 👈 nuevo
          IconButton(
            tooltip: 'Compartir tabla',
            icon: const Icon(Icons.share),
            onPressed: () => _shareStandings(context),
          ),
          IconButton(
            tooltip: 'Compartir tabla',
            icon: const Icon(Icons.share),
            onPressed: () => _shareStandings(context),
          ),
          IconButton(
            tooltip: 'Mis favoritos',
            icon: const Icon(Icons.star),
            onPressed: () => context.go('/favorites'),
          ),
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
      body: SafeArea(
        child: BlocBuilder<StandingsBloc, StandingsState>(
          builder: (context, state) => switch (state) {
            StandingsInitial() || StandingsLoading() => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            StandingsError(:final message) => _ErrorView(
              message: message,
              onRetry: () =>
                  context.read<StandingsBloc>().add(const StandingsRequested()),
            ),
            StandingsLoaded(:final standings) => _ResponsiveStandings(
              standings: standings,
            ),
          },
        ),
      ),
    );
  }

  Future<void> _shareStandings(BuildContext context) async {
    final state = context.read<StandingsBloc>().state;
    if (state is! StandingsLoaded) return;

    final top5 = state.standings
        .take(5)
        .map((t) => '${t.position}. ${t.shortName} - ${t.points} pts')
        .join('\n');
    final text =
        '🏆 Tabla de posiciones - Top 5\n$top5\n\nCompartido desde Liga App ⚽';

    final messenger = ScaffoldMessenger.of(context);

    try {
      final result = await sl<ShareService>().shareText(text);
      if (result == ShareResult.copiedToClipboard) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Tabla copiada al portapapeles 📋')),
        );
      }
    } on PlatformException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo compartir: ${e.message}')),
      );
    }
  }
}

/// Decide el diseño según el espacio disponible
class _ResponsiveStandings extends StatefulWidget {
  const _ResponsiveStandings({required this.standings});

  final List<TeamStanding> standings;

  @override
  State<_ResponsiveStandings> createState() => _ResponsiveStandingsState();
}

class _ResponsiveStandingsState extends State<_ResponsiveStandings> {
  TeamStanding? _selected;

  @override
  void didUpdateWidget(_ResponsiveStandings oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió la liga, se limpia la selección
    if (oldWidget.standings != widget.standings) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= Breakpoints.expanded;

        final list = _StandingsList(
          standings: widget.standings,
          selectedTeamId: isExpanded ? _selected?.teamId : null,
          onTeamTap: (team) {
            if (isExpanded) {
              setState(
                () => _selected = team,
              ); // ancho: muestra el detalle al lado
            } else {
              context.go(
                '/team/${team.teamId}',
                extra: team,
              ); // celular: navega
            }
          },
        );

        // 📱 Celular o tablet vertical: una columna, con ancho máximo
        if (!isExpanded) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: list,
            ),
          );
        }

        // 💻 Pantalla ancha: master-detail (lista + detalle)
        final selected = _selected;
        return Row(
          children: [
            SizedBox(width: 420, child: list),
            const VerticalDivider(width: 1),
            Expanded(
              child: selected == null
                  ? const Center(
                      child: Text(
                        'Selecciona un equipo para ver su detalle 👈',
                      ),
                    )
                  : TeamDetailContent(
                      key: ValueKey(selected.teamId),
                      team: selected,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _StandingsList extends StatelessWidget {
  const _StandingsList({
    required this.standings,
    required this.onTeamTap,
    this.selectedTeamId,
  });

  final List<TeamStanding> standings;
  final ValueChanged<TeamStanding> onTeamTap;
  final int? selectedTeamId;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
          return _FavoriteAwareTile(
            team: team,
            selected: team.teamId == selectedTeamId,
            onTap: () => onTeamTap(team),
          );
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

/// Una fila que sabe si su equipo es favorito (select redibuja SÓLO esta fila)
class _FavoriteAwareTile extends StatelessWidget {
  const _FavoriteAwareTile({
    required this.team,
    required this.onTap,
    this.selected = false,
  });

  final TeamStanding team;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isFavorite(team.teamId),
    );

    return StandingTile(
      standing: team,
      isFavorite: isFavorite,
      selected: selected,
      onFavoriteTap: () => context.read<FavoritesProvider>().toggle(
        FavoriteTeam(
          teamId: team.teamId,
          name: team.shortName,
          crestUrl: team.crestUrl,
        ),
      ),
      onTap: onTap,
    );
  }
}
