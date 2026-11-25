import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ConnectivityService {
  const ConnectivityService();

  // Mismo nombre que en Kotlin
  static const _channel = EventChannel('com.daniel.liga_app/connectivity');

  /// Emite true cuando hay internet y false cuando se pierde
  Stream<bool> watchConnection() {
    // Sólo Android tiene el código nativo. En las demás plataformas asumimos conexión.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Stream.value(true);
    }
    return _channel.receiveBroadcastStream().map((event) => event as bool);
  }
}
