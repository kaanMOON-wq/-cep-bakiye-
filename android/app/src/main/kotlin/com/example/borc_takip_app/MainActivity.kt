package com.example.borc_takip_app

import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.borc_takip_app/signature"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSignatureHash") {
                val hash = getSignatureHash()
                if (hash != null) {
                    result.success(hash)
                } else {
                    result.error("SIGNATURE_ERROR", "Could not get signature", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSignatureHash(): String? {
        return try {
            val pm = packageManager
            val packageName = packageName
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val pkgInfo = pm.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
                val certs = pkgInfo.signingInfo?.apkContentsSigners ?: return null
                val md = MessageDigest.getInstance("SHA-256")
                md.update(certs[0].toByteArray())
                md.digest().joinToString("") { "%02x".format(it) }
            } else {
                @Suppress("DEPRECATION")
                val pkgInfo = pm.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
                val certs = pkgInfo.signatures ?: return null
                val md = MessageDigest.getInstance("SHA-256")
                md.update(certs[0].toByteArray())
                md.digest().joinToString("") { "%02x".format(it) }
            }
        } catch (e: Exception) {
            null
        }
    }
}
