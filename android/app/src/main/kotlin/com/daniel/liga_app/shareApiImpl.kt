package com.daniel.liga_app

import android.app.Activity
import android.content.Intent

/// Implementa la interfaz que generó Pigeon
class ShareApiImpl(private val activity: Activity) : ShareApi {

    override fun share(message: ShareMessage) {
        // ¡Recibimos un OBJETO, no un Map!
        if (message.lines.isEmpty()) {
            throw FlutterError("EMPTY_MESSAGE", "No hay nada que compartir", null)
        }

        val text = buildString {
            appendLine(message.title)
            message.lines.forEach { appendLine(it) }
            append("\nCompartido desde Liga App ⚽")
        }

        val sendIntent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, text)
        }
        activity.startActivity(Intent.createChooser(sendIntent, message.title))
    }
}