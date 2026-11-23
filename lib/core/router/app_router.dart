
import 'package:go_router/go_router.dart';
import 'package:liga_app/features/standings/domain/entities/team_standing.dart';
import 'package:liga_app/features/standings/presentation/pages/standings_page.dart';
import 'package:liga_app/features/standings/presentation/pages/team_detail_page.dart';

final appRouter = GoRouter(
routes:[
  GoRoute(
      path: '/',
      builder: (context, state) => const StandingsPage(),
      routes: [
        GoRoute(
          path: 'team/:id',
          builder: (context, state) =>
              TeamDetailPage(team: state.extra as TeamStanding?),
        ),
      ],
    ),
]
);