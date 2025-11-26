<p align="center">
  <img src="./assets/images/green_connect_logo.png" alt="Green Connect Logo" width="120"/>
</p>

<h1 align="center">
  <img src="./assets/images/leaf_2.png" alt="Leaf Icon" width="30" />
  Green Connect Mobile
</h1>

<p align="center">
  [![Tests](https://github.com/AlexHa2/GreenConnectMobile/actions/workflows/tests.yml/badge.svg)](https://github.com/AlexHa2/GreenConnectMobile/actions)
  <img src="https://img.shields.io/badge/platform-flutter-blue" />
  <img src="https://img.shields.io/badge/architecture-clean--architecture-success" />
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

4. Run (Have to android emulator)

```bash
flutter run
```

5. Run debug (Have to android emulator)

```bash
flutter run --debug
```

6. Run Test

```bash
flutter test integration_test
or for detail
flutter test integration_test/authentication/login_test.dart
```

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
