import 'package:flutter/material.dart';
import 'package:liga_app/features/favorites/presentation/favorites_provider.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(sl())..load(),
      child: const LigaApp(),
    ),
  );
}

class LigaApp extends StatelessWidget {
  const LigaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Liga App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      routerConfig: appRouter,
    );
  }
}
