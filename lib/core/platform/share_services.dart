import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:liga_app/core/platform/pigeon/share_api.g.dart';

enum ShareResult { shared, copiedToClipboard }

class ShareService {
  final ShareApi _api;
  // La API de Pigeon se puede inyectar (útil para usar una falsa en los tests)
  ShareService({ShareApi? api}) : _api = api ?? ShareApi();

  Future<ShareResult> share({
    required String title,
    required List<String> lines,
  }) async {
    // Sólo Android tiene la implementación nativa
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      // ¡Enviamos un OBJETO con tipos, no un Map!
      await _api.share(ShareMessage(title: title, lines: lines));
      return ShareResult.shared;
    }

    // Plan B (web, iOS, escritorio): copiar al portapapeles
    final text = [
      title,
      ...lines,
      '',
      'Compartido desde Liga App ⚽',
    ].join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    return ShareResult.copiedToClipboard;
  }
}
