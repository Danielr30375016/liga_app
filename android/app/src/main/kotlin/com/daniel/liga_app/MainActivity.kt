package com.daniel.liga_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val connectivityChannel = "com.daniel.liga_app/connectivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Pigeon: compartir (reemplaza el MethodChannel escrito a mano)
        ShareApi.setUp(flutterEngine.dartExecutor.binaryMessenger, ShareApiImpl(this))

        // EventChannel: conexión (igual que antes)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, connectivityChannel)
            .setStreamHandler(ConnectivityStreamHandler(this))
    }
}
