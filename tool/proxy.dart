// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  // 1. Lee la API key del archivo env/dev.json
  final config = jsonDecode(
    await File('env/dev.json').readAsString(),
  ) as Map<String, dynamic>;
  final apiKey = config['FOOTBALL_API_KEY'] as String;

  // 2. Crea el "cliente" para hablar con la API real
  final client = HttpClient();

  // 3. Enciende el servidor en tu PC, puerto 8080
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('✅ Proxy escuchando en http://127.0.0.1:8080');

  // 4. Cada vez que llegue una petición de la app...
  server.listen((request) async {
    // 5. Agrega los permisos CORS para el navegador
    request.response.headers
      ..set('Access-Control-Allow-Origin', '*')
      ..set('Access-Control-Allow-Methods', 'GET, OPTIONS')
      ..set('Access-Control-Allow-Headers', '*');

    // 6. Responde la "pregunta de permiso" del navegador
    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      return;
    }

    try {
      // 7. Reenvía la petición a la API real, con la key
      final target = Uri.parse('https://api.football-data.org${request.uri}');
      final apiRequest = await client.getUrl(target);
      apiRequest.headers.set('X-Auth-Token', apiKey);
      final apiResponse = await apiRequest.close();

      // 8. Devuelve la respuesta de la API a la app
      print('${apiResponse.statusCode}  ${request.uri}');
      request.response.statusCode = apiResponse.statusCode;
      request.response.headers.contentType = ContentType.json;
      await apiResponse.pipe(request.response);
    } catch (e) {
      // 9. Si algo falla, avisa a la app con un error
      request.response.statusCode = HttpStatus.badGateway;
      request.response.write(jsonEncode({'error': e.toString()}));
      await request.response.close();
    }
  });
}
