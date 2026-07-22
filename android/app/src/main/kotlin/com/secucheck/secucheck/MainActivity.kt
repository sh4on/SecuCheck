package com.secucheck.secucheck

import android.app.AppOpsManager
import android.app.KeyguardManager
import android.app.admin.DevicePolicyManager
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.InputStream
import java.net.NetworkInterface

// main activity — hosts the flutter engine and exposes all native system security checks via method channel
class MainActivity : FlutterActivity() {

    // method channel name — must match the dart-side channel name exactly
    private val channelName = "secucheck/security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // register the method channel and dispatch calls to the appropriate native security check handler
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                // category 1: os & privileges
                "checkRootAccess"            -> result.success(checkRootAccess())
                "checkBootloaderStatus"      -> result.success(checkBootloaderStatus())
                "checkOsVersion"             -> result.success(checkOsVersion())

                // category 2: developer & debug controls
                "checkDeveloperOptions"      -> result.success(checkDeveloperOptions())
                "checkUsbDebugging"          -> result.success(checkUsbDebugging())
                "checkWirelessDebugging"     -> result.success(checkWirelessDebugging())
                "checkMockLocation"          -> result.success(checkMockLocation())

                // category 3: app runtime & installation environment
                "checkOverlayPermission"     -> result.success(checkOverlayPermission())
                "checkAccessibilityServices" -> result.success(checkAccessibilityServices())
                "checkUnknownSources"        -> result.success(checkUnknownSources())

                // category 4: network & inspection vulnerabilities
                "checkCustomCaCerts"         -> result.success(checkCustomCaCerts())
                "checkVpnOrProxy"            -> result.success(checkVpnOrProxy())

                // category 5: emulators & virtual environments
                "checkEmulator"              -> result.success(checkEmulator())
                "checkVirtualContainers"     -> result.success(checkVirtualContainers())

                // category 6: physical & hardware risks
                "checkScreenLock"            -> result.success(checkScreenLock())
                "checkStorageEncryption"     -> result.success(checkStorageEncryption())

                else                         -> result.notImplemented()
            }
        }
    }

    // ─── category 1: os & privileges checks ─────────────────────────────────

    /**
     * check for root access by:
     * 1. looking for common `su` binary paths
     * 2. inspecting build tags for "test-keys" (custom/rooted ROM signature)
     * 3. checking if known root manager apps are installed (Magisk, KernelSU, etc.)
     */
    private fun checkRootAccess(): Map<String, Any> {
        var isRooted = false
        val indicators = mutableListOf<String>()

        // common locations where the su binary is placed on rooted devices
        val suPaths = arrayOf(
            "/system/bin/su",
            "/system/xbin/su",
            "/sbin/su",
            "/su/bin/su",
            "/data/local/su",
            "/data/local/xbin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/bin/su",
        )
        for (path in suPaths) {
            if (File(path).exists()) {
                isRooted = true
                indicators.add("su binary at $path")
            }
        }

        // production ROMs are signed with release-keys; test-keys indicate custom/rooted ROM
        val buildTags = Build.TAGS ?: ""
        if (buildTags.contains("test-keys")) {
            isRooted = true
            indicators.add("test-keys in build tags")
        }

        // check for well-known root manager / superuser app package names
        val rootPackages = arrayOf(
            "com.topjohnwu.magisk",
            "com.kingroot.kinguser",
            "com.kingo.root",
            "eu.chainfire.supersu",
            "me.weishu.kernelsu",
            "io.github.huskydg.magisk",
        )
        for (pkg in rootPackages) {
            try {
                packageManager.getPackageInfo(pkg, 0)
                isRooted = true
                indicators.add("root manager installed: $pkg")
            } catch (_: PackageManager.NameNotFoundException) {
                // package not found — expected on clean devices
            }
        }

        return mapOf(
            "isRooted"   to isRooted,
            "indicators" to indicators,
        )
    }

    /**
     * check bootloader lock status via android system properties
     */
    private fun checkBootloaderStatus(): Map<String, Any> {
        var isUnlocked = false
        var statusMessage = "Bootloader locked"

        try {
            val flashLocked = getSystemProperty("ro.boot.flash.locked")
            val verifiedState = getSystemProperty("ro.boot.verifiedbootstate")

            if (flashLocked == "0" || verifiedState.equals("orange", ignoreCase = true) || verifiedState.equals("red", ignoreCase = true)) {
                isUnlocked = true
                statusMessage = "Bootloader is UNLOCKED (verifiedstate: $verifiedState, flash.locked: $flashLocked)"
            }
        } catch (_: Exception) {
            statusMessage = "Could not verify bootloader state"
        }

        return mapOf(
            "isUnlocked"    to isUnlocked,
            "statusMessage" to statusMessage,
        )
    }

    /**
     * return android os version details and security patch level.
     * warns if android version < 12 (API < 31) or security patch level is old.
     */
    private fun checkOsVersion(): Map<String, Any> {
        val apiLevel      = Build.VERSION.SDK_INT
        val release       = Build.VERSION.RELEASE ?: "Unknown"
        val securityPatch = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Build.VERSION.SECURITY_PATCH ?: "Unknown"
        } else {
            "Pre-Android 6"
        }
        val isOutdated = apiLevel < 31 // Android 12 (API 31) minimum target

        return mapOf(
            "apiLevel"      to apiLevel,
            "release"       to release,
            "securityPatch" to securityPatch,
            "isOutdated"    to isOutdated,
        )
    }

    // ─── category 2: developer & debug controls checks ───────────────────────

    /**
     * check if developer options are enabled in settings
     */
    private fun checkDeveloperOptions(): Map<String, Any> {
        val isEnabled = Settings.Global.getInt(
            contentResolver,
            Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
            0,
        ) != 0

        return mapOf("isEnabled" to isEnabled)
    }

    /**
     * check if usb debugging (adb) is enabled
     */
    private fun checkUsbDebugging(): Map<String, Any> {
        val isEnabled = Settings.Global.getInt(
            contentResolver,
            Settings.Global.ADB_ENABLED,
            0,
        ) != 0

        return mapOf("isEnabled" to isEnabled)
    }

    /**
     * check if wireless debugging (adb over wi-fi) is active (API 30+)
     */
    private fun checkWirelessDebugging(): Map<String, Any> {
        var isWirelessActive = false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val wirelessAdb = Settings.Global.getInt(
                contentResolver,
                "adb_wifi_enabled",
                0,
            )
            isWirelessActive = (wirelessAdb != 0)
        }

        return mapOf("isWirelessActive" to isWirelessActive)
    }

    /**
     * iterate all installed non-system apps to detect active mock location providers
     */
    private fun checkMockLocation(): Map<String, Any> {
        val appOps   = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
        val mockApps = mutableListOf<String>()

        for (app in packages) {
            if (app.flags and ApplicationInfo.FLAG_SYSTEM != 0) continue

            val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_MOCK_LOCATION,
                    app.uid,
                    app.packageName,
                )
            } else {
                @Suppress("DEPRECATION")
                appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_MOCK_LOCATION,
                    app.uid,
                    app.packageName,
                )
            }

            if (mode == AppOpsManager.MODE_ALLOWED) {
                mockApps.add(app.packageName)
            }
        }

        return mapOf(
            "hasMockLocation" to mockApps.isNotEmpty(),
            "mockApps"        to mockApps,
        )
    }

    // ─── category 3: app runtime & installation environment checks ───────────

    /**
     * check if overlay permission (draw over other apps) is granted
     */
    private fun checkOverlayPermission(): Map<String, Any> {
        val isGranted = Settings.canDrawOverlays(this)
        return mapOf("isGranted" to isGranted)
    }

    /**
     * check for enabled third-party accessibility services
     */
    private fun checkAccessibilityServices(): Map<String, Any> {
        val enabledServices = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
        ) ?: ""

        val thirdPartyServices = mutableListOf<String>()

        if (enabledServices.isNotEmpty()) {
            val services = enabledServices.split(":")
            for (service in services) {
                val trimmed = service.trim()
                if (trimmed.isNotBlank() &&
                    !trimmed.startsWith("com.android") &&
                    !trimmed.startsWith("com.google") &&
                    !trimmed.startsWith("com.samsung") &&
                    !trimmed.startsWith("android")
                ) {
                    thirdPartyServices.add(trimmed)
                }
            }
        }

        return mapOf(
            "hasThirdPartyServices" to thirdPartyServices.isNotEmpty(),
            "services"              to thirdPartyServices,
        )
    }

    /**
     * check if sideloading / unknown sources installation is allowed
     */
    private fun checkUnknownSources(): Map<String, Any> {
        val isAllowed = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            packageManager.canRequestPackageInstalls()
        } else {
            @Suppress("DEPRECATION")
            Settings.Secure.getInt(
                contentResolver,
                Settings.Secure.INSTALL_NON_MARKET_APPS,
                0,
            ) != 0
        }

        return mapOf("isAllowed" to isAllowed)
    }

    // ─── category 4: network & inspection vulnerabilities checks ────────────

    /**
     * check for user-installed custom CA certificates in system user cert store
     */
    private fun checkCustomCaCerts(): Map<String, Any> {
        var hasUserCerts = false
        var certCount = 0

        val userCertDir = File("/data/misc/user/0/cacerts-added")
        if (userCertDir.exists() && userCertDir.isDirectory) {
            val files = userCertDir.listFiles()
            if (files != null && files.isNotEmpty()) {
                hasUserCerts = true
                certCount = files.size
            }
        }

        return mapOf(
            "hasUserCerts" to hasUserCerts,
            "certCount"    to certCount,
        )
    }

    /**
     * detect vpn interfaces / proxies
     */
    private fun checkVpnOrProxy(): Map<String, Any> {
        var vpnDetected   = false
        var proxyDetected = false
        val details       = mutableListOf<String>()

        try {
            val interfaces = NetworkInterface.getNetworkInterfaces()
            if (interfaces != null) {
                for (iface in interfaces.toList()) {
                    val name = iface.name.lowercase()
                    if (name.startsWith("tun") ||
                        name.startsWith("ppp") ||
                        name.startsWith("tap")
                    ) {
                        vpnDetected = true
                        details.add("VPN interface: ${iface.name}")
                    }
                }
            }
        } catch (_: Exception) { }

        try {
            val cm      = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val network = cm.activeNetwork
            if (network != null) {
                val caps = cm.getNetworkCapabilities(network)
                if (caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
                    vpnDetected = true
                    details.add("VPN transport active")
                }
            }
        } catch (_: Exception) { }

        val proxyHost = System.getProperty("http.proxyHost")
        val proxyPort = System.getProperty("http.proxyPort")
        if (!proxyHost.isNullOrEmpty()) {
            proxyDetected = true
            details.add("HTTP proxy: $proxyHost:$proxyPort")
        }

        return mapOf(
            "vpnDetected"   to vpnDetected,
            "proxyDetected" to proxyDetected,
            "details"       to details,
        )
    }

    // ─── category 5: emulators & virtual environments checks ────────────────

    /**
     * detect emulator execution
     */
    private fun checkEmulator(): Map<String, Any> {
        val fingerprint  = Build.FINGERPRINT  ?: ""
        val model        = Build.MODEL        ?: ""
        val manufacturer = Build.MANUFACTURER ?: ""
        val hardware     = Build.HARDWARE     ?: ""
        val product      = Build.PRODUCT      ?: ""
        val brand        = Build.BRAND        ?: ""

        val isEmulator = (
            fingerprint.startsWith("generic") ||
            fingerprint.startsWith("unknown") ||
            model.contains("google_sdk", ignoreCase = true) ||
            model.contains("Emulator", ignoreCase = true) ||
            model.contains("Android SDK built for x86", ignoreCase = true) ||
            manufacturer.contains("Genymotion", ignoreCase = true) ||
            hardware.contains("goldfish") ||
            hardware.contains("ranchu") ||
            product.contains("sdk") ||
            product.contains("vbox86p") ||
            brand.startsWith("generic")
        )

        return mapOf(
            "isEmulator"  to isEmulator,
            "model"       to model,
            "fingerprint" to fingerprint,
        )
    }

    /**
     * detect virtual app containers / dual workspace apps (Parallel Space, Dual Apps, VirtualXposed)
     */
    private fun checkVirtualContainers(): Map<String, Any> {
        var isVirtual = false
        val detectedApps = mutableListOf<String>()

        val virtualPackages = arrayOf(
            "com.lbe.parallel",
            "com.lbe.parallel.intl",
            "com.parallel.space.lite",
            "com.dual.space",
            "com.cloneapp.parallelspace",
            "io.va.exposed",
            "com.vmos.app",
            "com.x8sandbox",
        )

        for (pkg in virtualPackages) {
            try {
                packageManager.getPackageInfo(pkg, 0)
                isVirtual = true
                detectedApps.add(pkg)
            } catch (_: PackageManager.NameNotFoundException) { }
        }

        return mapOf(
            "isVirtual"    to isVirtual,
            "detectedApps" to detectedApps,
        )
    }

    // ─── category 6: physical & hardware risks checks ────────────────────────

    /**
     * check screen lock security status
     */
    private fun checkScreenLock(): Map<String, Any> {
        val km       = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        val isSecure = km.isKeyguardSecure

        return mapOf("isSecure" to isSecure)
    }

    /**
     * check storage encryption status
     */
    private fun checkStorageEncryption(): Map<String, Any> {
        var isEncrypted = false
        var statusText = "Encrypted"

        try {
            val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
            val status = dpm.storageEncryptionStatus

            isEncrypted = (status == DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE ||
                           status == DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE_PER_USER)

            statusText = when (status) {
                DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE          -> "Storage Encrypted (Active)"
                DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE_PER_USER -> "Storage Encrypted (Per User)"
                DevicePolicyManager.ENCRYPTION_STATUS_INACTIVE        -> "Storage Unencrypted (Inactive)"
                else                                                   -> "Encryption Status: $status"
            }
        } catch (_: Exception) {
            statusText = "Encryption Status Unknown"
        }

        return mapOf(
            "isEncrypted" to isEncrypted,
            "statusText"  to statusText,
        )
    }

    // ─── helper utilities ────────────────────────────────────────────────────

    private fun getSystemProperty(propName: String): String {
        return try {
            val p = Runtime.getRuntime().exec("getprop $propName")
            val input: InputStream = p.inputStream
            val text = input.bufferedReader().use { it.readText() }.trim()
            text
        } catch (_: Exception) {
            ""
        }
    }
}
