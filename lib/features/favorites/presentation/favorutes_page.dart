import 'package:flutter/material.dart';
import 'package:liga_app/features/standings/presentation/widgets/standings_tile.dart';
import 'package:provider/provider.dart';

import 'favorites_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis favoritos')),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.favorites.isEmpty) {
            return const Center(
              child: Text(
                'Aún no tienes favoritos.\nToca la ⭐ en la tabla para agregar uno.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final team = provider.favorites[index];
              return ListTile(
                leading: TeamCrest(url: team.crestUrl, size: 36),
                title: Text(team.name),
                trailing: IconButton(
                  tooltip: 'Quitar de favoritos',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => provider.toggle(team),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
