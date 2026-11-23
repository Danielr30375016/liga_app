import 'package:flutter/material.dart';

import '../../domain/entities/team_standing.dart';

class StandingTile extends StatelessWidget {
  const StandingTile({super.key, required this.standing, this.onTap});

  final TeamStanding standing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: 72,
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '${standing.position}',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            TeamCrest(url: standing.crestUrl, size: 36),
          ],
        ),
      ),
      title: Text(standing.shortName, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        'PJ ${standing.playedGames} · G ${standing.won} · E ${standing.draw} · P ${standing.lost}',
      ),
      trailing: Text(
        '${standing.points} pts',
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Escudo del equipo, con un ícono por si la imagen no carga
class TeamCrest extends StatelessWidget {
  const TeamCrest({super.key, required this.url, this.size = 40});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(Icons.shield_outlined, size: size);
    if (url.isEmpty) return fallback;

    return Image.network(
      url,
      width: size,
      height: size,
      // En web: si la imagen tiene problemas de CORS, la muestra con <img> del navegador
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}