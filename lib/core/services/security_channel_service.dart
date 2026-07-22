import 'package:flutter/services.dart';

// wrapper around the native android method channel for all security checks across 6 risk categories.
// each method maps to a corresponding kotlin function in MainActivity.kt.
class SecurityChannelService {
  // channel name must match the value registered in MainActivity.kt
  static const MethodChannel _channel = MethodChannel('secucheck/security');

  // singleton instance
  static final SecurityChannelService _instance =
      SecurityChannelService._internal();

  SecurityChannelService._internal();

  static SecurityChannelService get instance => _instance;

  // invoke a named method on the native channel and return the result as a map.
  // on PlatformException, returns a map with an 'error' key to allow graceful handling.
  Future<Map<String, dynamic>> _invoke(final String method) async {
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(method);
      // convert the platform map (Map<Object?, Object?>) to a typed dart map
      return result?.cast<String, dynamic>() ?? {};
    } on PlatformException catch (e) {
      // surface the native error without crashing the scan
      return {'error': e.message ?? 'Unknown native error for $method'};
    } on MissingPluginException {
      // channel not registered — may happen during unit tests or on non-android
      return {'error': 'Channel not available. Android only.'};
    }
  }

  // category 1: os & privileges
  Future<Map<String, dynamic>> checkRootAccess() => _invoke('checkRootAccess');
  Future<Map<String, dynamic>> checkBootloaderStatus() =>
      _invoke('checkBootloaderStatus');
  Future<Map<String, dynamic>> checkOsVersion() => _invoke('checkOsVersion');

  // category 2: developer & debug controls
  Future<Map<String, dynamic>> checkDeveloperOptions() =>
      _invoke('checkDeveloperOptions');
  Future<Map<String, dynamic>> checkUsbDebugging() =>
      _invoke('checkUsbDebugging');
  Future<Map<String, dynamic>> checkWirelessDebugging() =>
      _invoke('checkWirelessDebugging');
  Future<Map<String, dynamic>> checkMockLocation() =>
      _invoke('checkMockLocation');

  // category 3: app runtime & installation environment
  Future<Map<String, dynamic>> checkOverlayPermission() =>
      _invoke('checkOverlayPermission');
  Future<Map<String, dynamic>> checkAccessibilityServices() =>
      _invoke('checkAccessibilityServices');
  Future<Map<String, dynamic>> checkUnknownSources() =>
      _invoke('checkUnknownSources');

  // category 4: network & inspection vulnerabilities
  Future<Map<String, dynamic>> checkCustomCaCerts() =>
      _invoke('checkCustomCaCerts');
  Future<Map<String, dynamic>> checkVpnOrProxy() => _invoke('checkVpnOrProxy');

  // category 5: emulators & virtual environments
  Future<Map<String, dynamic>> checkEmulator() => _invoke('checkEmulator');
  Future<Map<String, dynamic>> checkVirtualContainers() =>
      _invoke('checkVirtualContainers');

  // category 6: physical & hardware risks
  Future<Map<String, dynamic>> checkScreenLock() => _invoke('checkScreenLock');
  Future<Map<String, dynamic>> checkStorageEncryption() =>
      _invoke('checkStorageEncryption');
}
