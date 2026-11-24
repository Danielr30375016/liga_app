import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

enum ShareResult { shared, copiedToClipboard }

class ShareService {
  const ShareService();

  // Mismo nombre que en Kotlin
  static const _channel = MethodChannel('com.daniel.liga_app/share');

  Future<ShareResult> shareText(String text) async {
    if (!kIsWeb) {
      try {
        await _channel.invokeMethod<void>('shareText', {'text': text});
        return ShareResult.shared;
      } on MissingPluginException {
        // Plataforma sin código nativo (por ejemplo, Windows): usamos el plan B
      }
    }

    // Plan B: copiar al portapapeles
    await Clipboard.setData(ClipboardData(text: text));
    return ShareResult.copiedToClipboard;
  }
}
