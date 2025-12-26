<p align="center">
  <img src="./assets/images/green_connect_logo.png" alt="Green Connect Logo" width="120"/>
</p>

<h1 align="center">
  <img src="./assets/images/leaf_2.png" alt="Leaf Icon" width="30" />
  Green Connect Mobile
</h1>

<p align="center">
  <p align="center">
  <!-- CI -->
  <a href="https://github.com/AlexHa2/GreenConnectMobile/actions/workflows/flutter_integration_test.yml">
    <img src="https://github.com/AlexHa2/GreenConnectMobile/actions/workflows/flutter_integration_test.yml/badge.svg"
         alt="Flutter Integration Tests" />
  </a>

  <!-- Platform & Architecture -->
  <img src="https://img.shields.io/badge/platform-flutter-blue" />
  <img src="https://img.shields.io/badge/architecture-clean--architecture-success" />
  <img src="https://img.shields.io/badge/pattern-MVVM-orange" />

  <!-- License -->
  <a href="https://github.com/AlexHa2/GreenConnectMobile/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/AlexHa2/GreenConnectMobile"
         alt="License" />
  </a>

  <!-- Security -->
  <a href="https://github.com/AlexHa2/GreenConnectMobile/security/policy">
    <img src="https://img.shields.io/badge/security-policy-green"
         alt="Security Policy" />
  </a>
    <!-- Last Commit -->
  <a href="https://github.com/AlexHa2/GreenConnectMobile/commits/main">
    <img src="https://img.shields.io/github/last-commit/AlexHa2/GreenConnectMobile"
         alt="Last Commit" />
  </a>
</p>

</p>

<p align="left">
  <i><b>Green Connect</b> is a mobile platform for recycling exchange, allowing users to sell, trade, or donate recyclable waste.</i>
</p>

<p align="left">
  👥 <b>Connects:</b> ♻️ Collectors  • 🏠 Households 
</p>

<p align="left">
  📱 Built with <b>Flutter</b> — Clean Architecture + Riverpod for scalable state management.
</p>

## 📂 Folder Structure

```bash
project_root/
├── integration_test/                  # Integration / end-to-end tests
│   ├── authentication/
│   │   └── login_test.dart            # Login flow test
│   └── helpers/                       # Helper utilities for tests
│       ├── app_actions.dart           # Common app actions for tests
│       ├── finders.dart               # Custom finders for widgets
│       └── test_utils.dart            # Utility functions for tests
└── lib/
    ├── main.dart                      # App entry point
    ├── core/                          # Core shared modules
    │   ├── config/
    │   │   ├── env.dart               # Environment configuration (dev, prod)
    │   │   ├── app_theme.dart         # App theme (light/dark mode, fonts, colors)
    │   │   └── app_constants.dart     # Global constants
    │   ├── di/
    │   │   └── injector.dart          # Dependency Injection setup (GetIt / Riverpod)
    │   ├── error/
    │   │   ├── app_exception.dart     # Custom exceptions
    │   │   └── failure.dart           # Business logic error definitions
    │   ├── network/
    │   │   ├── api_client.dart        # HTTP/DIO client
    │   │   ├── api_endpoints.dart     # API endpoints
    │   │   └── network_checker.dart   # Network connectivity checker
    │   ├── route/
    │   │   └── app_router.dart        # App router configuration (GoRouter / AutoRoute)
    │   └── helper/
    │       ├── validators.dart        # Input validation functions
    │       ├── formatters.dart        # Data formatters
    │       └── utils.dart             # Miscellaneous helper functions
    ├── shared/                        # Shared resources
    │   ├── layouts/
    │   │   ├── layout_homepage.dart   # Homepage layout
    │   │   └── layout_admin.dart      # Admin layout
    │   ├── styles/
    │   │   ├── app_colors.dart        # Color definitions
    │   │   ├── app_spacing.dart       # Spacing constants
    │   │   └── app_text_styles.dart   # Text styles
    │   ├── widgets/
    │   │   ├── button_gradient.dart   # Gradient button widget
    │   │   ├── input_field.dart       # Custom input field
    │   │   └── app_snackbar.dart      # Snackbar widget
    │   └── constants/
    │       └── app_images.dart        # Image asset paths
    ├── features/                      # Feature modules
    │   ├── authentication/
    │   │   ├── data/
    │   │   │   ├── datasources/
    │   │   │   │   ├── auth_local_datasource.dart    # Local data source
    │   │   │   │   └── auth_remote_datasource.dart   # Remote API data source
    │   │   │   ├── models/
    │   │   │   │   └── user_dto.dart                # Data Transfer Objects
    │   │   │   └── repositories/
    │   │   │       └── auth_repository_impl.dart   # Repository implementation
    │   │   ├── domain/
    │   │   │   ├── entities/
    │   │   │   │   └── user.dart                   # Business entities
    │   │   │   ├── repositories/
    │   │   │   │   └── auth_repository.dart       # Repository interface
    │   │   │   └── usecases/
    │   │   │       └── login_usecase.dart         # Business logic (UseCase)
    │   │   └── presentation/
    │   │       ├── providers/
    │   │       │   └── auth_provider.dart        # State management provider
    │   │       ├── viewmodels/
    │   │       │   └── login_viewmodel.dart      # UI logic & state
    │   │       └── views/
    │   │           ├── login_page.dart
    │   │           ├── register_page.dart
    │   │           └── welcome_page.dart
    │   ├── profile/
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │       ├── viewmodels/
    │   │       └── views/
    │   ├── transaction/
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │       ├── viewmodels/
    │   │       └── views/
    │   └── notification/
    │       ├── data/
    │       ├── domain/
    │       └── presentation/
    │           ├── viewmodels/
    │           └── views/
    ├── generated/                      # Auto-generated files by intl / build_runner
    │   └── l10n.dart
    └── l10n/                           # Localization files
        ├── intl_en.arb                 # English translations
        └── intl_vi.arb                 # Vietnamese translations

```

## 🚀 Getting Started

1. Clone the repository

```bash
git clone https://github.com/GreenConnectDevTeam/GreenConnectMobile.git
cd GreenConnectMobile
```

2. Install dependencies

```bash
flutter pub get
```

3. Set up environment file

```bash
cp .env.example .env
```

Then edit `.env` and update `BASE_URL` if needed:
```env
BASE_URL=http://10.0.2.2:8000/api  # For Android Emulator
```

4. **🔥 Setup Firebase Configuration**

   Firebase configuration files are **NOT** included in version control for security reasons. You need to set them up after cloning:

   **Option 1: Using Setup Script (Recommended)**
   
   Windows (PowerShell):
   ```powershell
   .\setup_firebase.ps1
   ```
   
   macOS/Linux:
   ```bash
   chmod +x setup_firebase.sh
   ./setup_firebase.sh
   ```

   **Option 2: Manual Setup**
   
   Copy the template files and update with your Firebase credentials:
   ```bash
   # Android
   cp android/app/google-services.json.example android/app/google-services.json
   
   # iOS
   cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
   
   # Dart Firebase Options
   cp lib/core/config/firebase_options.dart.example lib/core/config/firebase_options.dart
   ```

   **Then update these files with your actual Firebase credentials:**
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - `lib/core/config/firebase_options.dart`

   > 📘 **Where to get Firebase credentials?**
   > 1. Go to [Firebase Console](https://console.firebase.google.com/)
   > 2. Select your project: `greenconnectplatform`
   > 3. Go to Project Settings > General
   > 4. Download configuration files for each platform
   > 5. Or use FlutterFire CLI: `flutterfire configure`
   > 6. Place the `firebase_options.dart` file in the `config` folder.
   > ⚠️ **Without real Firebase credentials, authentication won't work!**

5. Run the app

**Make sure Android Emulator or iOS Simulator is running first!**

```bash
# Run in release mode
flutter run --release

# Or run in debug mode (for development)
flutter run --debug
```

6. Run Tests

```bash
# Run unit tests
flutter test

# Run simple integration test (verify CI/CD setup)
flutter test integration_test/simple_test.dart

# Run authentication UI tests (some tests skipped without Firebase)
flutter test integration_test/authentication/login_test.dart

# Run with device/emulator (recommended for full integration tests)
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/simple_test.dart
```

> 📝 **Test Files**:
> - `simple_test.dart` - Sanity check test for CI/CD (no Firebase required)
> - `authentication/login_test.dart` - UI/Navigation tests (Firebase-dependent tests auto-skipped)
> 
> See [`integration_test/CI_CD_TESTING.md`](integration_test/CI_CD_TESTING.md) for details.

## 📝 Commit Rules (Commitlint)

We follow the Conventional Commits
standard for commit messages. **[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)**:

### 🔹 Common Commit Types

| Type        | Description                                                           |
| ----------- | --------------------------------------------------------------------- |
| ✨ feat     | Add a new feature                                                     |
| 🐛 fix      | Fix a bug                                                             |
| 📝 docs     | Documentation changes (README, comments, etc.)                        |
| 🎨 style    | Code style changes that don’t affect logic (formatting, spaces, etc.) |
| ♻️ refactor | Code refactoring without adding features or fixing bugs               |
| ✅ test     | Add or modify tests                                                   |
| ⚙️ chore    | Update tools, configs, or packages without affecting app behavior     |

### 🔹 Examples

```bash
git commit -m "feat(auth): add login with email/password"
git commit -m "fix(user): handle null avatar in profile"
git commit -m "docs: update README with folder structure"
```

## 📌 Core Technologies

- [Flutter](https://flutter.dev/) (Dart)
- [Riverpod](https://riverpod.dev/) – State Management
- [Dio](https://pub.dev/packages/dio) – Networking
- [GetIt](https://pub.dev/packages/get_it) – Dependency Injection
- [intl](https://pub.dev/packages/intl) – Localization & i18n

## 👨‍💻 Contribution Guide

1. 🍴 **Fork** the repository
2. 🌱 Create a new branch: `feature/feature-name`
3. ✅ Commit following [Commitlint](#-quy-tắc-commit-commitlint)
4. 🚀 Create a **Pull Request**

## 📄 License

MIT Lflutter run --debugicense © 2025 Green Connect
