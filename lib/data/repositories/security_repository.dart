import '../../core/constants/app_strings.dart';
import '../../core/services/security_channel_service.dart';
import '../models/security_check_model.dart';
import '../models/security_report_model.dart';

// repository that orchestrates all 16 native security checks across 6 risk categories
// and maps raw platform results into typed domain models with risk scoring
class SecurityRepository {
  final SecurityChannelService _service;

  // allow injecting a custom service for unit testing; defaults to singleton instance
  SecurityRepository({final SecurityChannelService? service})
      : _service = service ?? SecurityChannelService.instance;

  // run all 16 checks concurrently and return a complete SecurityReportModel
  Future<SecurityReportModel> runFullScan() async {
    // execute all native platform channel calls in parallel for optimal scan speed
    final results = await Future.wait([
      // category 1
      _service.checkRootAccess(),            // 0
      _service.checkBootloaderStatus(),      // 1
      _service.checkOsVersion(),             // 2

      // category 2
      _service.checkDeveloperOptions(),      // 3
      _service.checkUsbDebugging(),          // 4
      _service.checkWirelessDebugging(),     // 5
      _service.checkMockLocation(),          // 6

      // category 3
      _service.checkUnknownSources(),        // 7
      _service.checkAccessibilityServices(),  // 8
      _service.checkOverlayPermission(),     // 9

      // category 4
      _service.checkCustomCaCerts(),         // 10
      _service.checkVpnOrProxy(),            // 11

      // category 5
      _service.checkEmulator(),              // 12
      _service.checkVirtualContainers(),     // 13

      // category 6
      _service.checkScreenLock(),            // 14
      _service.checkStorageEncryption(),      // 15
    ]);

    // category 1: operating system & privilege modifications
    final catOsPrivileges = SecurityCategoryModel(
      id: 'cat_os_privileges',
      title: AppStrings.catOsPrivileges,
      checks: [
        _mapRoot(results[0]),
        _mapBootloader(results[1]),
        _mapOsVersion(results[2]),
      ],
    );

    // category 2: developer & debugging configurations
    final catDevControls = SecurityCategoryModel(
      id: 'cat_dev_controls',
      title: AppStrings.catDevControls,
      checks: [
        _mapDeveloperOptions(results[3]),
        _mapUsbDebugging(results[4]),
        _mapWirelessDebugging(results[5]),
        _mapMockLocation(results[6]),
      ],
    );

    // category 3: app installation & runtime protections
    final catAppRuntime = SecurityCategoryModel(
      id: 'cat_app_runtime',
      title: AppStrings.catAppRuntime,
      checks: [
        _mapUnknownSources(results[7]),
        _mapAccessibility(results[8]),
        _mapOverlay(results[9]),
      ],
    );

    // category 4: network & inspection vulnerabilities
    final catNetworkPrivacy = SecurityCategoryModel(
      id: 'cat_network_privacy',
      title: AppStrings.catNetworkPrivacy,
      checks: [
        _mapCustomCaCerts(results[10]),
        _mapVpnProxy(results[11]),
      ],
    );

    // category 5: emulators & virtual environments
    final catEmulatorsVirtual = SecurityCategoryModel(
      id: 'cat_emulators_virtual',
      title: AppStrings.catEmulatorsVirtual,
      checks: [
        _mapEmulator(results[12]),
        _mapVirtualContainers(results[13]),
      ],
    );

    // category 6: physical & hardware risks
    final catPhysicalHardware = SecurityCategoryModel(
      id: 'cat_physical_hardware',
      title: AppStrings.catPhysicalHardware,
      checks: [
        _mapScreenLock(results[14]),
        _mapStorageEncryption(results[15]),
      ],
    );

    final categories = [
      catOsPrivileges,
      catDevControls,
      catAppRuntime,
      catNetworkPrivacy,
      catEmulatorsVirtual,
      catPhysicalHardware,
    ];

    // calculate score: start at 100, deduct points per detected vulnerability (scoreImpact <= 0)
    var score = 100;
    for (final category in categories) {
      for (final check in category.checks) {
        score += check.scoreImpact;
      }
    }

    return SecurityReportModel(
      categories: categories,
      score: score.clamp(0, 100),
      scanTime: DateTime.now(),
    );
  }

  // ─── category 1 mappers ──────────────────────────────────────────────────

  SecurityCheckModel _mapRoot(final Map<String, dynamic> r) {
    final isRooted = r['isRooted'] as bool? ?? false;
    final indicators = (r['indicators'] as List?)?.cast<String>() ?? [];
    return SecurityCheckModel(
      id: 'root_access',
      name: AppStrings.checkRootAccess,
      description:
          'Checks for su binaries, test-keys in build tags, and root manager apps '
          '(Magisk, KernelSU, SuperSU).',
      status: isRooted ? CheckStatus.critical : CheckStatus.safe,
      detail: isRooted
          ? 'Root indicators: ${indicators.join(', ')}'
          : 'No root indicators found.',
      scoreImpact: isRooted ? -20 : 0,
      fixRecommendation: isRooted ? AppStrings.fixRoot : null,
    );
  }

  SecurityCheckModel _mapBootloader(final Map<String, dynamic> r) {
    final isUnlocked = r['isUnlocked'] as bool? ?? false;
    final statusMessage = r['statusMessage'] as String? ?? '';
    return SecurityCheckModel(
      id: 'bootloader',
      name: AppStrings.checkBootloader,
      description:
          'Verifies if the bootloader is locked. An unlocked bootloader allows '
          'flashing custom kernels and unauthorized system partitions.',
      status: isUnlocked ? CheckStatus.critical : CheckStatus.safe,
      detail: statusMessage,
      scoreImpact: isUnlocked ? -20 : 0,
      fixRecommendation: isUnlocked ? AppStrings.fixBootloader : null,
    );
  }

  SecurityCheckModel _mapOsVersion(final Map<String, dynamic> r) {
    final apiLevel = r['apiLevel'] as int? ?? 0;
    final release = r['release'] as String? ?? 'Unknown';
    final securityPatch = r['securityPatch'] as String? ?? 'Unknown';
    final isOutdated = r['isOutdated'] as bool? ?? false;
    return SecurityCheckModel(
      id: 'os_version',
      name: AppStrings.checkOsVersion,
      description:
          'Verifies Android OS version meets modern security baseline (Android 12 / API 31+). '
          'Reports system security patch level.',
      status: isOutdated ? CheckStatus.warning : CheckStatus.safe,
      detail: isOutdated
          ? 'Android $release (API $apiLevel, Patch: $securityPatch) — update recommended'
          : 'Android $release (API $apiLevel, Patch: $securityPatch) — up to date',
      scoreImpact: isOutdated ? -10 : 0,
      fixRecommendation: isOutdated ? AppStrings.fixOsVersion : null,
    );
  }

  // ─── category 2 mappers ──────────────────────────────────────────────────

  SecurityCheckModel _mapDeveloperOptions(final Map<String, dynamic> r) {
    final isEnabled = r['isEnabled'] as bool? ?? false;
    return SecurityCheckModel(
      id: 'dev_options',
      name: AppStrings.checkDeveloperOptions,
      description:
          'Checks if Developer Options are enabled in device settings. '
          'Exposes internal debugging interfaces on production devices.',
      status: isEnabled ? CheckStatus.warning : CheckStatus.safe,
      detail: isEnabled ? 'Developer Options are ON.' : 'Developer Options are OFF.',
      scoreImpact: isEnabled ? -10 : 0,
      fixRecommendation: isEnabled ? AppStrings.fixDeveloperOptions : null,
    );
  }

  SecurityCheckModel _mapUsbDebugging(final Map<String, dynamic> r) {
    final isEnabled = r['isEnabled'] as bool? ?? false;
    return SecurityCheckModel(
      id: 'usb_debugging',
      name: AppStrings.checkUsbDebugging,
      description:
          'USB Debugging (ADB) lets connected computers execute arbitrary commands. '
          'An attacker with physical access can extract app data.',
      status: isEnabled ? CheckStatus.critical : CheckStatus.safe,
      detail: isEnabled ? 'USB Debugging is ON.' : 'USB Debugging is OFF.',
      scoreImpact: isEnabled ? -20 : 0,
      fixRecommendation: isEnabled ? AppStrings.fixUsbDebugging : null,
    );
  }

  SecurityCheckModel _mapWirelessDebugging(final Map<String, dynamic> r) {
    final isWirelessActive = r['isWirelessActive'] as bool? ?? false;
    return SecurityCheckModel(
      id: 'wireless_debugging',
      name: AppStrings.checkWirelessDebugging,
      description:
          'Checks if Wireless ADB Debugging is active over Wi-Fi network interfaces.',
      status: isWirelessActive ? CheckStatus.critical : CheckStatus.safe,
      detail: isWirelessActive
          ? 'Wireless ADB Debugging is ACTIVE over Wi-Fi!'
          : 'Wireless Debugging is inactive.',
      scoreImpact: isWirelessActive ? -15 : 0,
      fixRecommendation: isWirelessActive ? AppStrings.fixWirelessDebugging : null,
    );
  }

  SecurityCheckModel _mapMockLocation(final Map<String, dynamic> r) {
    final hasMock = r['hasMockLocation'] as bool? ?? false;
    final apps = (r['mockApps'] as List?)?.cast<String>() ?? [];
    return SecurityCheckModel(
      id: 'mock_location',
      name: AppStrings.checkMockLocation,
      description:
          'Detects user apps with permission to feed spoofed GPS location data.',
      status: hasMock ? CheckStatus.warning : CheckStatus.safe,
      detail: hasMock
          ? 'Mock location apps: ${apps.join(', ')}'
          : 'No mock location apps detected.',
      scoreImpact: hasMock ? -10 : 0,
      fixRecommendation: hasMock ? AppStrings.fixMockLocation : null,
    );
  }

  // ─── category 3 mappers ──────────────────────────────────────────────────

  SecurityCheckModel _mapUnknownSources(final Map<String, dynamic> r) {
    final isAllowed = r['isAllowed'] as bool? ?? false;
    return SecurityCheckModel(
      id: 'unknown_sources',
      name: AppStrings.checkUnknownSources,
      description:
          'Checks if installing APK files outside Google Play is permitted.',
      status: isAllowed ? CheckStatus.warning : CheckStatus.safe,
      detail:
          isAllowed ? 'Sideloading is ENABLED.' : 'Sideloading is disabled.',
      scoreImpact: isAllowed ? -10 : 0,
      fixRecommendation: isAllowed ? AppStrings.fixUnknownSources : null,
    );
  }

  SecurityCheckModel _mapAccessibility(final Map<String, dynamic> r) {
    final hasServices = r['hasThirdPartyServices'] as bool? ?? false;
    final services = (r['services'] as List?)?.cast<String>() ?? [];
    return SecurityCheckModel(
      id: 'accessibility',
      name: AppStrings.checkAccessibility,
      description:
          'Third-party accessibility services can read UI content and log screen inputs.',
      status: hasServices ? CheckStatus.warning : CheckStatus.safe,
      detail: hasServices
          ? 'Active services: ${services.join(', ')}'
          : 'No third-party accessibility services active.',
      scoreImpact: hasServices ? -10 : 0,
      fixRecommendation: hasServices ? AppStrings.fixAccessibility : null,
    );
  }

  SecurityCheckModel _mapOverlay(final Map<String, dynamic> r) {
    final isGranted = r['isGranted'] as bool? ?? false;
    return SecurityCheckModel(
      id: 'overlay',
      name: AppStrings.checkOverlay,
      description:
          'SYSTEM_ALERT_WINDOW (Draw Over Other Apps) permission can be abused for clickjacking attacks.',
      status: isGranted ? CheckStatus.warning : CheckStatus.safe,
      detail: isGranted
          ? 'Overlay permission is GRANTED.'
          : 'No overlay permission detected.',
      scoreImpact: isGranted ? -10 : 0,
      fixRecommendation: isGranted ? AppStrings.fixOverlay : null,
    );
  }

  // ─── category 4 mappers ──────────────────────────────────────────────────

  SecurityCheckModel _mapCustomCaCerts(final Map<String, dynamic> r) {
    final hasUserCerts = r['hasUserCerts'] as bool? ?? false;
    final certCount = r['certCount'] as int? ?? 0;
    return SecurityCheckModel(
      id: 'custom_ca_certs',
      name: AppStrings.checkCustomCaCerts,
      description:
          'Detects user-installed custom CA certificates that allow HTTPS traffic inspection.',
      status: hasUserCerts ? CheckStatus.critical : CheckStatus.safe,
      detail: hasUserCerts
          ? 'Detected $certCount user-installed CA certificate(s)'
          : 'No custom user CA certificates found.',
      scoreImpact: hasUserCerts ? -20 : 0,
      fixRecommendation: hasUserCerts ? AppStrings.fixCustomCaCerts : null,
    );
  }

  SecurityCheckModel _mapVpnProxy(final Map<String, dynamic> r) {
    final vpn = r['vpnDetected'] as bool? ?? false;
    final proxy = r['proxyDetected'] as bool? ?? false;
    final details = (r['details'] as List?)?.cast<String>() ?? [];
    final hasAny = vpn || proxy;
    return SecurityCheckModel(
      id: 'vpn_proxy',
      name: AppStrings.checkVpnProxy,
      description:
          'Detects active VPN tunnel interfaces or configured HTTP proxies.',
      status: hasAny ? CheckStatus.info : CheckStatus.safe,
      detail: hasAny ? details.join('; ') : 'No active VPN or proxy detected.',
      scoreImpact: hasAny ? -5 : 0,
      fixRecommendation: hasAny ? AppStrings.fixVpnProxy : null,
    );
  }

  // ─── category 5 mappers ──────────────────────────────────────────────────

  SecurityCheckModel _mapEmulator(final Map<String, dynamic> r) {
    final isEmulator = r['isEmulator'] as bool? ?? false;
    final model = r['model'] as String? ?? '';
    return SecurityCheckModel(
      id: 'emulator',
      name: AppStrings.checkEmulator,
      description:
          'Detects whether the app is executing inside an Android emulator environment.',
      status: isEmulator ? CheckStatus.warning : CheckStatus.safe,
      detail:
          isEmulator ? 'Emulator detected: $model' : 'Running on real physical hardware.',
      scoreImpact: isEmulator ? -10 : 0,
      fixRecommendation: isEmulator ? AppStrings.fixEmulator : null,
    );
  }

  SecurityCheckModel _mapVirtualContainers(final Map<String, dynamic> r) {
    final isVirtual = r['isVirtual'] as bool? ?? false;
    final apps = (r['detectedApps'] as List?)?.cast<String>() ?? [];
    return SecurityCheckModel(
      id: 'virtual_containers',
      name: AppStrings.checkVirtualContainers,
      description:
          'Detects app cloners, dual space containers, or virtual app hooks.',
      status: isVirtual ? CheckStatus.critical : CheckStatus.safe,
      detail: isVirtual
          ? 'Virtual container apps detected: ${apps.join(', ')}'
          : 'No virtual space apps detected.',
      scoreImpact: isVirtual ? -20 : 0,
      fixRecommendation: isVirtual ? AppStrings.fixVirtualContainers : null,
    );
  }

  // ─── category 6 mappers ──────────────────────────────────────────────────

  SecurityCheckModel _mapScreenLock(final Map<String, dynamic> r) {
    final isSecure = r['isSecure'] as bool? ?? false;
    return SecurityCheckModel(
      id: 'screen_lock',
      name: AppStrings.checkScreenLock,
      description:
          'Verifies if screen lock authentication (PIN/Pattern/Password/Biometrics) is active.',
      status: isSecure ? CheckStatus.safe : CheckStatus.critical,
      detail: isSecure
          ? 'Screen lock authentication configured.'
          : 'No screen lock detected — device is unprotected!',
      scoreImpact: isSecure ? 0 : -20,
      fixRecommendation: isSecure ? null : AppStrings.fixScreenLock,
    );
  }

  SecurityCheckModel _mapStorageEncryption(final Map<String, dynamic> r) {
    final isEncrypted = r['isEncrypted'] as bool? ?? false;
    final statusText = r['statusText'] as String? ?? '';
    return SecurityCheckModel(
      id: 'storage_encryption',
      name: AppStrings.checkStorageEncryption,
      description:
          'Checks full-disk or file-based storage encryption state.',
      status: isEncrypted ? CheckStatus.safe : CheckStatus.warning,
      detail: statusText,
      scoreImpact: isEncrypted ? 0 : -10,
      fixRecommendation: isEncrypted ? null : AppStrings.fixStorageEncryption,
    );
  }
}
