import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    // Dónde se genera el código de Dart
    dartOut: 'lib/core/platform/pigeon/share_api.g.dart',
    // Dónde se genera el código de Kotlin
    kotlinOut: 'android/app/src/main/kotlin/com/daniel/liga_app/ShareApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.daniel.liga_app'),
  ),
)
/// Lo que viaja de Dart a Kotlin: ¡un objeto, no un Map!
class ShareMessage {
  ShareMessage({required this.title, required this.lines});

  String title;
  List<String> lines;
}

/// La API que implementa Android (el "host") y que Dart llama
@HostApi()
abstract class ShareApi {
  void share(ShareMessage message);
}
