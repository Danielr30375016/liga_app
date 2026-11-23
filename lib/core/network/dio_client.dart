import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:liga_app/core/config/env.dart';

abstract final class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: kIsWeb
            ? 'http://127.0.0.1:8080/v4/'
            : 'https://api.football-data.org/v4/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Agrega la API key a TODAS las peticiones
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!kIsWeb) {
            options.headers['X-auth-token'] = Env.footballApiKey;
          }
          handler.next(options);
        },
      ),
    );
    // Muestra en consola cada petición (sin los headers, para no mostrar la key)
    dio.interceptors.add(
      LogInterceptor(requestHeader: false, responseBody: false),
    );

    return dio;
  }
}
