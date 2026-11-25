import 'package:flutter/material.dart';

import '../di/injection.dart';
import '../platform/connectivity_service.dart';

class ConnectionIndicator extends StatefulWidget {
  const ConnectionIndicator({super.key});

  @override
  State<ConnectionIndicator> createState() => _ConnectionIndicatorState();
}

class _ConnectionIndicatorState extends State<ConnectionIndicator> {
  // Se crea UNA vez en initState, no en cada build
  late final Stream<bool> _connection;

  @override
  void initState() {
    super.initState();
    _connection = sl<ConnectivityService>().watchConnection();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _connection,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        return Tooltip(
          message: isOnline ? 'Conectado' : 'Sin conexión',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              color: isOnline ? null : Colors.red,
            ),
          ),
        );
      },
    );
  }
}
