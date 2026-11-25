package com.daniel.liga_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val shareChannel = "com.daniel.liga_app/share"
    private val connectivityChannel = "com.daniel.liga_app/connectivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel: compartir (Dart pregunta, Kotlin responde UNA vez)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shareChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "shareText" -> {
                        val text = call.argument<String>("text")
                        if (text.isNullOrBlank()) {
                            result.error("INVALID_TEXT", "El texto está vacío", null)
                        } else {
                            shareText(text)
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // EventChannel: conexión (Kotlin avisa MUCHAS veces)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, connectivityChannel)
            .setStreamHandler(ConnectivityStreamHandler(this))
    }

    private fun shareText(text: String) {
        val sendIntent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, text)
        }
        startActivity(Intent.createChooser(sendIntent, "Compartir tabla"))
    }
}
