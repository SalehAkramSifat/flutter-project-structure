# 🚀 Flutter Enterprise Starter Architecture

A clean, modular, and production-ready **Flutter Starter Boilerplate** designed to accelerate mobile application development. It provides a battle-tested core foundation featuring hardware-encrypted storage, a resilient network layer, reusable UI widgets, input validators, and adaptive responsive utilities.

---

## 📑 Table of Contents
- [🎯 Purpose & Philosophy](#-purpose--philosophy)
- [📂 Directory & File Tree](#-directory--file-tree)
- [⚡ Core Features & Modules](#-core-features--modules)
  - [1. Security & Storage (AuthService)](#1-security--storage-authservice)
  - [2. Resilient Networking (NetworkCaller & ResponseData)](#2-resilient-networking-networkcaller--responsedata)
  - [3. Common UI Component Library](#3-common-ui-component-library)
  - [4. Form Validation Suite (AppValidator)](#4-form-validation-suite-appvalidator)
  - [5. Utilities & Formatters](#5-utilities--formatters)
  - [6. Secure Logging (AppLogger)](#6-secure-logging-applogger)
- [🚀 Getting Started](#-getting-started)
- [🛠️ How to Implement a New Feature](#️-how-to-implement-a-new-feature)
- [🧪 Code Quality & Verification](#-code-quality--verification)

---

## 🎯 Purpose & Philosophy

Starting a new Flutter project often requires days of repetitive boilerplate setup—configuring auth token storage, building network error handlers, creating custom buttons, handling responsive screens, and setting up form validation.

This architecture solves that by providing:
* **Zero Boilerplate:** Standard UI widgets, validation logic, and network callers are pre-built and tested.
* **Security by Default:** Encrypted token storage (Android Keystore + iOS Keychain) and release-mode log gating prevent credential leakage.
* **Resilience:** The network layer gracefully handles offline states, timeouts, and HTML/Cloudflare error responses without crashing.
* **Clean Code:** 100% compliant with Flutter analysis rules (**0 errors, 0 warnings, 0 lints**).

---

## 📂 Directory & File Tree

```text
lib/
├── app.dart                                # Root MaterialApp setup with Sizer & theme routing
├── main.dart                               # Application entrypoint with AuthService initialization
│
├── core/                                   # Shared core modules (The Backbone)
│   ├── binding/
│   │   └── app_binding.dart                # Global GetX bindings & dependency injection
│   │
│   ├── common/                             # Production-ready reusable UI components
│   │   ├── custom_align_text.dart          # Customizable aligned text component
│   │   ├── custom_appbar.dart              # Consistent branded AppBar with back action
│   │   ├── custom_confirmation_popup.dart  # Modal dialog for confirmation & alert actions
│   │   ├── custom_empty_message.dart       # Empty state placeholder with icons & buttons
│   │   ├── custom_outline_button.dart      # Secondary outlined action button
│   │   ├── custom_submit_button.dart       # Primary CTA button with integrated loading state
│   │   ├── custom_text.dart                # Standardized typography wrapper with GoogleFonts
│   │   ├── custom_textformfield.dart       # Form field with visibility toggle, icons & validator
│   │   ├── doted_divider.dart              # Dotted/dashed separator widget
│   │   ├── expandable_custom_text.dart     # "Read More / Read Less" toggleable text
│   │   ├── full_screen_photo_viewer.dart   # Interactive photo viewer with smooth double-tap zoom
│   │   ├── loader_helper.dart              # Loading state controller & overlays
│   │   ├── network_image_handler.dart      # Network image handler with shimmer loader & fallback
│   │   ├── pdf_viewer_screen.dart          # Full-featured PDF viewer with reload & download guards
│   │   ├── permission_disclosure_dialog.dart # Google Play policy-compliant permission dialog
│   │   └── pinput/                         # Specialized OTP / PIN input module
│   │       ├── custom_pinput.dart          # Pinput widget with error animations & haptic feedback
│   │       └── custom_pinput_theme.dart    # 4 distinct pin themes (Rounded, Filled, Circle, Underline)
│   │
│   ├── helper/
│   │   └── pdf_downloader.dart             # Background file downloader saving to device storage
│   │
│   ├── logging/
│   │   └── logger.dart                     # Colorized, emoji-rich logger (disabled in release mode)
│   │
│   ├── models/
│   │   └── response_data.dart              # Generic type-safe network response wrapper (ResponseData<T>)
│   │
│   ├── services/
│   │   ├── auth_service.dart               # Hardware-encrypted secure token storage & session manager
│   │   └── network_caller.dart             # HTTP client (GET, POST, PUT, PATCH, DELETE, Multipart)
│   │
│   ├── theme/
│   │   └── app_theme.dart                  # Light and Dark ThemeData configurations
│   │
│   ├── utils/                              # Constants, formatters, and device utilities
│   │   ├── app_colors.dart                 # Clean, zero-bloat color palette
│   │   ├── app_sizer.dart                  # Figma 390x844 responsive scaling (.w, .h, .sp, .r)
│   │   ├── app_texts.dart                  # Static application text constants
│   │   ├── app_urls.dart                   # Centralized API endpoints and base URLs
│   │   ├── date_format.dart                # 17+ date & time formatters supporting String & DateTime
│   │   ├── distance_calculate.dart         # Haversine formula geospatial distance calculator
│   │   ├── icon_path.dart                  # Asset icon paths
│   │   ├── image_path.dart                 # Asset image paths
│   │   └── time_ago_helper.dart            # Relative time helper ("Just now", "5m ago", "2 hours ago")
│   │
│   └── validation/
│       └── app_validator.dart              # Form validators (Email, Passwords, Phone, Name, URL, etc.)
│
├── feature/                                # Business logic & UI modules (Feature-Driven)
│   └── splash/                             # Initial splash screen placeholder
│       └── splash_screen.dart
│
└── route/
    └── app_routes.dart                     # GetX declarative routing map
```

---

## ⚡ Core Features & Modules

### 1. Security & Storage (`AuthService`)
Located at: `lib/core/services/auth_service.dart`
* **Hardware-Backed Encryption:** Stores sensitive JWT tokens, user IDs, and roles using `FlutterSecureStorage` (Android Keystore + iOS Keychain).
* **Zero-Lag Synchronous Access:** Initializes once in `main.dart` and caches credentials in memory. Access tokens synchronously with zero async delay via `AuthService.token` and `AuthService.hasToken()`.
* **Clean Logout:** `AuthService.logoutUser()` wipes encrypted storage and routes immediately to the login screen.

### 2. Resilient Networking (`NetworkCaller` & `ResponseData`)
Located at: `lib/core/services/network_caller.dart`
* **Complete Method Support:** Direct support for `getRequest`, `postRequest`, `putRequest`, `patchRequest`, `deleteRequest`.
* **Multi-Part File Uploads:** Supports dynamic field names and file uploads via `multipartPostRequest`, `multipartPatchRequest`, and `multipartPutRequest`.
* **HTML & Crash Protection:** Contains `_safeDecode` to prevent app crashes when servers or Cloudflare return HTML 502/500 pages.
* **Readable Console Logs:** Prints clear status emojis (`🌐 GET`, `🚀 POST`, `✅ 200`, `🔒 401`, `⏱️ ❌ Timeout`).
* **Type-Safe Generic Models:** `ResponseData<T>` allows typed mapping:
  ```dart
  ResponseData<UserModel> result = response.map((json) => UserModel.fromJson(json));
  ```

### 3. Common UI Component Library
Located at: `lib/core/common/`
* **Buttons:** `CustomSubmitButton` (with reactive loading spinner) and `CustomOutlineButton`.
* **Text Inputs:** `CustomTextFormField` (supports prefix/suffix icons, visibility toggle, and validation).
* **OTP / Pin:** `CustomPinput` with 4 pre-built styles (`roundedBox`, `filled`, `circle`, `underline`).
* **Media Handlers:** `NetworkImageHandler` (with shimmer loader), `FullScreenPhotoViewer` (with double-tap zoom), and `PdfViewerScreen` (with download progress).
* **Policy Compliance:** `PermissionDisclosureDialog` meeting Google Play store user disclosure requirements.

### 4. Form Validation Suite (`AppValidator`)
Located at: `lib/core/validation/app_validator.dart`
* **Email:** RFC-compliant regex supporting all modern top-level domains (`.online`, `.tech`, `.agency`, `.com`) with auto-trim.
* **Password Separation:** 
  * `validatePassword`: Standard 6+ character check for login screens.
  * `validateStrongPassword`: Strict check (uppercase, lowercase, number, special character) for registration.
* **Confirm Password:** Ensures password matching for password reset / signup.
* **Phone Numbers:** Flexible validation for local (`017XXXXXXXX`) and international (`+88017XXXXXXXX`) formats.
* **Other Validators:** `validateRequired`, `validateName`, `validateNumber`, and `validateUrl`.

### 5. Utilities & Formatters
Located at: `lib/core/utils/`
* **`AppSizer` (`.w`, `.h`, `.sp`, `.r`):** Adapts pixel values based on Figma design canvas (`390 x 844`). Includes fallback values preventing `LateInitializationError`.
* **`DateFormatter`:** Handles 17+ common date/time formats, accepting both `DateTime` and `String` inputs with calendar-accurate `Today` / `Yesterday` / `Tomorrow` calculations.
* **`TimeAgoHelper`:** Returns human-readable relative time ("Just now", "5m ago", "2 hours ago", "3 days ago").
* **`DistanceCalculator`:** Calculates geographical distance between two latitude/longitude points via the Haversine formula.

### 6. Secure Logging (`AppLogger`)
Located at: `lib/core/logging/logger.dart`
* **Release Mode Security:** Automatically turns off in release mode (`Level.off`) to prevent sensitive user data, PII, and auth tokens from leaking into production device logs.
* **JSON Pretty-Printing:** `AppLogger.json(data)` formats complex nested API payloads with indentation.

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (3.24.0 or higher recommended)
* Dart SDK (3.5.0 or higher)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/SalehAkramSifat/flutter-project-structure.git
   ```
2. Navigate to the project root:
   ```bash
   cd flutter-project-structure
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the project:
   ```bash
   flutter run
   ```

---

## 🛠️ How to Implement a New Feature

When adding a new feature (e.g., `auth`), follow the recommended feature directory structure:

```text
lib/feature/auth/
├── controller/
│   └── auth_controller.dart     # GetXController handling UI state & logic
├── model/
│   └── user_model.dart          # Data classes & fromJson/toJson serializers
└── view/
    ├── login_screen.dart        # Screen UI using CustomTextFormField & CustomSubmitButton
    └── register_screen.dart
```

### Example: Making an API Call in a Controller
```dart
import 'package:get/get.dart';
import 'package:flutter_project_structure/core/services/network_caller.dart';
import 'package:flutter_project_structure/core/services/auth_service.dart';
import 'package:flutter_project_structure/core/utils/app_urls.dart';

class AuthController extends GetxController {
  final NetworkCaller _network = NetworkCaller();
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    final response = await _network.postRequest(
      AppUrls.login,
      body: {'email': email, 'password': password},
    );

    isLoading.value = false;

    if (response.isSuccess) {
      final token = response.responseData['token'];
      await AuthService.saveToken(token);
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Error', response.errorMessage);
    }
  }
}
```

---

## 🧪 Code Quality & Verification

Verify the codebase anytime by running Flutter's static analysis tool:

```bash
flutter analyze
```

**Result:**
```text
Analyzing flutter-project-structure...
No issues found!
```

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
