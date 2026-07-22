// all ui-visible strings, labels, and descriptions used throughout the app
abstract final class AppStrings {
  // app identity
  static const String appName = 'SecuCheck';
  static const String appTagline = 'Device Risk Auditor';

  // dashboard & report labels
  static const String dashboardTitle = 'Security Dashboard';
  static const String scanButtonLabel = 'Run Security Scan';
  static const String reScanButtonLabel = 'Re-Scan Device';
  static const String scanningLabel = 'Scanning device...';
  static const String viewFullReport = 'View Full Report';
  static const String securityScoreLabel = 'Security Score';
  static const String preScanHint = 'Tap below to start\nyour security audit';

  // category titles across the 6 risk categories
  static const String catOsPrivileges = 'OS & Privileges';
  static const String catDevControls = 'Developer & Debug Controls';
  static const String catAppRuntime = 'App Runtime & Installation';
  static const String catNetworkPrivacy = 'Network & Inspection';
  static const String catEmulatorsVirtual = 'Emulators & Virtualization';
  static const String catPhysicalHardware = 'Physical & Hardware Risks';
  static const String catHardwareGuide = 'Educational Hardware Security Guide';

  // check titles
  static const String checkRootAccess = 'Root Access';
  static const String checkBootloader = 'Bootloader Lock Status';
  static const String checkOsVersion = 'OS Version & Patch';

  static const String checkDeveloperOptions = 'Developer Options';
  static const String checkUsbDebugging = 'USB Debugging (ADB)';
  static const String checkWirelessDebugging = 'Wireless Debugging';
  static const String checkMockLocation = 'Mock Location Providers';

  static const String checkOverlay = 'Overlay Permission (System Alert)';
  static const String checkAccessibility = 'Accessibility Services';
  static const String checkUnknownSources = 'Unknown Sources (Sideloading)';

  static const String checkCustomCaCerts = 'User CA Certificates';
  static const String checkVpnProxy = 'VPN / Proxy Connection';

  static const String checkEmulator = 'Emulator Detection';
  static const String checkVirtualContainers = 'Virtual / Dual Workspaces';

  static const String checkScreenLock = 'Screen Lock Authentication';
  static const String checkStorageEncryption = 'Storage Encryption';

  // status badge labels
  static const String statusSafe = 'Safe';
  static const String statusWarning = 'Warning';
  static const String statusCritical = 'Critical';
  static const String statusInfo = 'Info';

  // audit report labels
  static const String auditReportTitle = 'Audit Report';
  static const String checksPassedLabel = 'checks passed';
  static const String checksFailedLabel = 'issues found';
  static const String allChecksPassed = 'All checks passed';
  static const String issuesSuffix = 'issues found';

  // ui state messages
  static const String loadingMessage = 'Analyzing device security...';
  static const String errorMessage = 'Scan failed. Please try again.';
  static const String emptyScanMessage =
      'No scan results yet.\nRun a scan from the Dashboard.';
  static const String retryLabel = 'Retry';

  // hardware guide — juice jacking
  static const String hwJuiceJackingTitle = 'Juice Jacking';
  static const String hwJuiceJackingDesc =
      'Public USB charging ports can be weaponized by attackers to inject malware '
      'or exfiltrate data through the USB data lines. Always use a charge-only cable '
      'or a USB data blocker ("USB condom") when charging at public kiosks.';

  // hardware guide — jtag/uart
  static const String hwJtagTitle = 'Unsealed JTAG / UART Ports';
  static const String hwJtagDesc =
      'Physical debug ports (JTAG/UART) exposed on device PCBs can grant an attacker '
      'a root debug shell. Avoid purchasing devices from unverified secondary sources.';

  // hardware guide — rogue cell towers
  static const String hwRogueCellTitle = 'Rogue Cell Towers (IMSI Catchers)';
  static const String hwRogueCellDesc =
      'Fake cellular base stations (Stingrays) can silently intercept '
      'SMS messages and unencrypted voice calls. Mitigate by using end-to-end encrypted '
      'messaging apps (e.g., Signal).';

  // hardware guide — info note
  static const String hwInfoNote =
      'These physical hardware risks cannot be detected programmatically. Review each item manually.';

  // ─── fix recommendation strings for all 16 checks ─────────────────────────

  static const String fixRoot =
      'Unroot your device using the root manager app (e.g., Magisk → Uninstall) '
      'or perform a factory reset. Avoid using rooted devices for sensitive applications.';

  static const String fixBootloader =
      'Re-lock your bootloader via fastboot (`fastboot flashing lock`). '
      'An unlocked bootloader permits flashing unverified OS images.';

  static const String fixOsVersion =
      'Go to Settings → System → Software Update and install the latest Android '
      'update to receive critical system security patches.';

  static const String fixDeveloperOptions =
      'Go to Settings → Developer Options and toggle it OFF to reduce attack surface.';

  static const String fixUsbDebugging =
      'Go to Settings → Developer Options → USB Debugging and turn it OFF.';

  static const String fixWirelessDebugging =
      'Go to Settings → Developer Options → Wireless Debugging and turn it OFF.';

  static const String fixMockLocation =
      'Go to Settings → Developer Options → Mock Location App and set it to "None".';

  static const String fixOverlay =
      'Go to Settings → Apps → Special App Access → Display over other apps, '
      'and revoke overlay permission for non-trusted apps.';

  static const String fixAccessibility =
      'Go to Settings → Accessibility → Downloaded Apps and disable any '
      'third-party accessibility services you do not actively use.';

  static const String fixUnknownSources =
      'Go to Settings → Apps → Special App Access → Install Unknown Apps '
      'and revoke sideloading permissions.';

  static const String fixCustomCaCerts =
      'Go to Settings → Security → Trusted Credentials → User tab and remove '
      'untrusted custom CA certificates to prevent Man-in-the-Middle HTTPS interception.';

  static const String fixVpnProxy =
      'Disconnect from any unknown VPN or proxy server under Settings → Network & Internet → VPN.';

  static const String fixEmulator =
      'Run the application on an authentic physical Android device for valid security context.';

  static const String fixVirtualContainers =
      'Uninstall app cloning or virtual container platforms (e.g. Parallel Space) '
      'that isolate app processes outside standard Android sandbox protections.';

  static const String fixScreenLock =
      'Go to Settings → Security → Screen Lock and configure a secure PIN, pattern, or biometric authentication.';

  static const String fixStorageEncryption =
      'Enable full-disk or file-based encryption under Settings → Security → Encryption & Credentials.';
}
