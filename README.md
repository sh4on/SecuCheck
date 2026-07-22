# SecuCheck — Device Risk Auditor 🛡️

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![GetX](https://img.shields.io/badge/State_Management-GetX-8A2BE2)](https://pub.dev/packages/get)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)](https://android.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**SecuCheck** is a production-ready, clean-architecture mobile security auditing application built for Android using **Flutter** and native **Kotlin MethodChannels**. It scans the target Android device across **6 critical security risk categories** (16 programmatic & educational security checks), calculates an overall **Security Health Score (0–100%)**, and provides actionable, step-by-step remediation advice to fix detected vulnerabilities.

---

## 📌 Features & Key Capabilities

- **🔍 6 Risk Categories & 16 Comprehensive Checks**: Complete coverage of device security surface without requiring invasive root or administrative permissions.
- **📈 Dynamic Security Score Engine**: Calculates a real-time health score (0–100%) using weighted risk impact deductions.
- **🎨 Modern Dark Security Dashboard**: Built with Material 3 dark aesthetics, animated custom circular progress score gauge, collapsible category sections, and severity status badges (`Safe`, `Warning`, `Critical`, `Info`).
- **🛠️ Actionable Remediation Steps**: Every detected vulnerability includes a dedicated **"How to Fix"** section with clear instructions for the user.
- **🔄 One-Tap Re-Scanning**: Dynamically trigger fresh device security audits anytime from both the Dashboard and the Audit Report screens.
- **📚 Educational Hardware Security Guide**: Manual security awareness guides for hardware vectors that cannot be scanned programmatically (Juice Jacking, Unsealed JTAG/UART Debug Ports, Rogue Cell Towers).

---

## 📊 Security Audit Breakdown (6 Categories / 16 Checks)

### Category 1: Operating System & Privilege Modifications
| Check Name | Method / Implementation | Severity | Score Impact |
|---|---|---|---|
| **Root Access** | Checks `su` binary paths (`/system/bin/su`, `/system/xbin/su`, `/data/local/su`, etc.), inspects `Build.TAGS` for `test-keys`, and verifies package installation of root managers (`Magisk`, `KernelSU`, `SuperSU`). | `Critical` | `-20` |
| **Bootloader Lock Status** | Reads Android system properties (`ro.boot.flash.locked`, `ro.boot.verifiedbootstate`) to detect unlocked bootloaders. | `Critical` | `-20` |
| **OS Version & Security Patch** | Validates Android OS against modern baselines (Android 12 / API 31+) and inspects `Build.VERSION.SECURITY_PATCH`. | `Warning` | `-10` |

### Category 2: Developer & Debugging Configurations
| Check Name | Method / Implementation | Severity | Score Impact |
|---|---|---|---|
| **Developer Options** | Reads `Settings.Global.DEVELOPMENT_SETTINGS_ENABLED`. | `Warning` | `-10` |
| **USB Debugging (ADB)** | Reads `Settings.Global.ADB_ENABLED`. | `Critical` | `-20` |
| **Wireless Debugging** | Checks `adb_wifi_enabled` / `WIRELESS_ADB_ENABLED` over Wi-Fi networks (Android 11 / API 30+). | `Critical` | `-15` |
| **Mock Location Providers** | Queries `AppOpsManager` for active `OPSTR_MOCK_LOCATION` permissions granted to third-party apps. | `Warning` | `-10` |

### Category 3: App Installation & Runtime Protections
| Check Name | Method / Implementation | Severity | Score Impact |
|---|---|---|---|
| **Unknown Sources (Sideloading)** | Checks `packageManager.canRequestPackageInstalls()` / `INSTALL_NON_MARKET_APPS`. | `Warning` | `-10` |
| **Accessibility Services** | Reads `Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES` and filters out trusted system packages to flag untrusted third-party screen-reading/keylogging apps. | `Warning` | `-10` |
| **Overlay Permission** | Checks `Settings.canDrawOverlays` (SYSTEM_ALERT_WINDOW) to mitigate clickjacking attacks. | `Warning` | `-10` |

### Category 4: Network & Inspection Vulnerabilities
| Check Name | Method / Implementation | Severity | Score Impact |
|---|---|---|---|
| **User CA Certificates** | Inspects `/data/misc/user/0/cacerts-added` for user-installed custom CA certs that allow HTTPS Man-in-the-Middle (MitM) interception. | `Critical` | `-20` |
| **VPN / Proxy Connection** | Enumerates network interfaces for `tun`/`tap`/`ppp` adapters, inspects `NetworkCapabilities.TRANSPORT_VPN`, and reads `http.proxyHost` system properties. | `Info` | `-5` |

### Category 5: Emulators & Virtual Environments
| Check Name | Method / Implementation | Severity | Score Impact |
|---|---|---|---|
| **Emulator Detection** | Inspects `Build.FINGERPRINT`, `MODEL`, `MANUFACTURER`, `HARDWARE`, `PRODUCT`, `BRAND` for QEMU, Genymotion, or SDK fingerprints. | `Warning` | `-10` |
| **Virtual App Containers** | Queries Package Manager for active app cloners and dual workspace containers (`Parallel Space`, `Dual Space`, `VirtualXposed`, `VMOS`). | `Critical` | `-20` |

### Category 6: Physical & Hardware Risks
| Check Name | Method / Implementation | Severity | Score Impact |
|---|---|---|---|
| **Screen Lock Authentication** | Checks `KeyguardManager.isKeyguardSecure` (PIN, Pattern, Password, Biometrics). | `Critical` | `-20` |
| **Storage Encryption** | Checks `DevicePolicyManager.storageEncryptionStatus`. | `Warning` | `-10` |
| **Educational Hardware Security Guide** | Interactive manual checklist covering **Juice Jacking**, **Unsealed JTAG/UART Ports**, and **Rogue Cell Towers (IMSI Catchers)**. | `Info` | `0` |

---

## 🧮 Security Score Calculation Engine

The overall Security Health Score starts at **100 points** (perfect score) and deducts points based on the severity of detected vulnerabilities:

$$\text{Final Score} = \operatorname{clamp}\left(100 + \sum_{i=1}^{N} \text{scoreImpact}_i, \; 0, \; 100\right)$$

- **Critical Vulnerabilities**: `-20` points each
- **Wireless ADB / High Vulnerabilities**: `-15` points each
- **Warning Vulnerabilities**: `-10` points each
- **Informational Findings**: `-5` points each
- **Safe Checks**: `0` impact

---

## 🏗️ Architecture & Project Structure

The codebase strictly enforces **Clean Modular Architecture** with GetX state management:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Dark security dashboard palette
│   │   ├── app_sizes.dart          # Centralized spacing, margins, radii, icon sizes
│   │   ├── app_strings.dart        # All UI text, descriptions, & fix advice
│   │   └── app_text_styles.dart    # Google Fonts (Inter) typography
│   ├── services/
│   │   └── security_channel_service.dart # Platform channel wrapper
│   └── theme/
│       └── app_theme.dart          # Dark Material 3 theme configuration
│
├── data/
│   ├── models/
│   │   ├── security_check_model.dart  # Check result model with fix recommendation
│   │   └── security_report_model.dart # Category group & score aggregate model
│   └── repositories/
│       └── security_repository.dart   # Orchestrates scan & maps raw platform data
│
├── modules/
│   ├── dashboard/                  # Main dashboard screen module
│   │   ├── bindings/
│   │   ├── controllers/
│   │   └── screens/
│   │       └── widgets/            # Standalone screen widgets
│   └── audit_report/              # Detailed audit report module
│       ├── bindings/
│       ├── controllers/
│       └── screens/
│           └── widgets/
│
├── routes/
│   ├── app_pages.dart              # Named route map
│   └── app_routes.dart             # Named route constants
│
├── shared/
│   ├── bindings/
│   │   └── initial_binding.dart    # Global dependency injection
│   └── common_widgets/             # Reusable UI widgets across modules
│
├── main.dart                       # App entrypoint & orientation locks
└── my_app.dart                     # Root GetMaterialApp + ScreenUtil setup
```

---

## ⚡ Getting Started

### Prerequisites

- **Flutter SDK**: `>= 3.19.0`
- **Dart SDK**: `>= 3.3.0`
- **Android SDK**: API 21+ (Android 5.0 Lollipop or newer)
- **Java / Kotlin**: JDK 17, Kotlin 1.9+

### Build & Run Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/secucheck.git
   cd secucheck
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run static code analysis**:
   ```bash
   flutter analyze
   ```

4. **Run unit & widget test suite**:
   ```bash
   flutter test
   ```

5. **Run the app on an Android device or emulator**:
   ```bash
   flutter run
   ```

---

## 🔒 Security & Play Store Compliance

1. **Non-Invasive APIs**: Uses standard Android system query APIs (`Settings.Global`, `AppOpsManager`, `KeyguardManager`, `ConnectivityManager`). Does NOT request invasive permissions (such as `BIND_ACCESSIBILITY_SERVICE` or Device Admin) that lead to Google Play Store rejections.
2. **Zero External Data Leakage**: All security calculations, system inspections, and report generation take place **100% locally on the device**. No telemetry or user data is ever transmitted off the device.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
