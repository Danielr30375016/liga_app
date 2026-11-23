import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';

void main() {
  setupInjection();
  runApp(const LigaApp());
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