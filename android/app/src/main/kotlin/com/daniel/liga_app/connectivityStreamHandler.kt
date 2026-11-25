package com.daniel.liga_app

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

class ConnectivityStreamHandler(context: Context) : EventChannel.StreamHandler {

    private val connectivityManager =
        context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

    // Para enviar los eventos desde el hilo principal (Flutter lo exige)
    private val mainHandler = Handler(Looper.getMainLooper())

    private var networkCallback: ConnectivityManager.NetworkCallback? = null

    // Flutter se suscribió (alguien hizo listen al Stream)
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        // 1. Envía el estado actual de inmediato
        events.success(isConnected())

        // 2. Se queda escuchando los cambios de red
        val callback = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                mainHandler.post { events.success(true) }
            }

            override fun onLost(network: Network) {
                mainHandler.post { events.success(false) }
            }
        }
        connectivityManager.registerDefaultNetworkCallback(callback)
        networkCallback = callback
    }

    override fun onCancel(arguments: Any?) {
        networkCallback?.let { connectivityManager.unregisterNetworkCallback(it) }
        networkCallback = null
    }

    private fun isConnected(): Boolean {
        val network = connectivityManager.activeNetwork ?: return false
        val capabilities = connectivityManager.getNetworkCapabilities(network) ?: return false
        return capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
    }
}