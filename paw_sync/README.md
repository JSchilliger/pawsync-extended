# Paw Sync - Pet Lifecycle Management App

## Project Purpose

Paw Sync is a comprehensive, user-centric mobile application for pet owners (dogs, cats, NAC/exotic pets). It aims to serve as a complete lifecycle management platform for pets, connecting owners with essential services and information. The user experience will prioritize being clean, intuitive, and secure.

## 🚀 Critical Setup Instructions 🚀

**This project requires manual setup steps before it can be run locally.**

Due to limitations in automated environments, several crucial commands and configurations must be performed by you.

👉 **Please refer to the detailed guide: [MANUAL_SETUP_AND_NEXT_STEPS.md](MANUAL_SETUP_AND_NEXT_STEPS.md)** 👈

This guide covers:
*   Essential terminal commands (`flutter pub get`, `flutter gen-l10n`, `flutterfire configure`, etc.)
*   Firebase project creation and configuration (including `google-services.json` and `GoogleService-Info.plist`).
*   Key placeholders in the code that need your attention for full functionality.
*   Potential next steps in development.

**Quick Summary of Key Commands (details in the linked guide):**
1.  `flutter pub get`
2.  `flutter gen-l10n`
3.  `dart pub global activate flutterfire_cli` (if not already installed)
4.  `flutterfire configure`
5.  (If needed) `flutter create . --project-name paw_sync`

The agent has prepared the codebase with foundational elements including Firebase initialization in `main.dart`, theming, localization, basic routing, data models, and repository structures. Completing the manual setup will make these functional.

## Core Technologies & Architecture

This project is built using Flutter for cross-platform mobile development.

*   **State Management**: [Riverpod](https://riverpod.dev/) is used for all state management.
*   **Navigation**: [go_router](https://pub.dev/packages/go_router) manages all routing and navigation. All app routes are defined in `lib/core/routing/app_router.dart`.
*   **Backend**: Firebase is the chosen Backend-as-a-Service (BaaS) for Authentication, Cloud Firestore (database), and Firebase Cloud Storage (file storage). Repository interfaces and Firebase implementations are defined.
*   **Project Structure**: A feature-first architecture is adopted (e.g., `lib/features/pet_profile/`, `lib/features/reminders/`). Core functionalities are in `lib/core/`.
*   **Internationalization (i18n)**: Uses `flutter_localizations` and `intl`. ARB files are in `lib/core/localization/l10n/`. `l10n.yaml` configures string generation.
*   **Design System**: A central `theme.dart` file (`lib/core/theme/theme.dart`) defines the application's design system (colors, fonts, text styles). Custom themed widgets (`themed_buttons.dart`, `styled_card.dart`) promote consistency.
*   **Service Abstraction**: Interfaces for services like `NotificationService`, `StorageService`, `AnalyticsService` are defined in `lib/core/services/`.

## How to Run

1.  **Ensure Flutter is installed:** Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
2.  **COMPLETE THE CRITICAL SETUP INSTRUCTIONS:** Refer to **[MANUAL_SETUP_AND_NEXT_STEPS.md](MANUAL_SETUP_AND_NEXT_STEPS.md)**. This is essential.
3.  **Run the app (after setup):**
    ```bash
    cd paw_sync
    flutter run
    ```
    (Specific run commands for different flavors or emulators/devices will be added later as needed).

## Project Structure Overview

```
paw_sync/
├── AGENTS.md                     # Instructions for AI agents working on this repo
├── MANUAL_SETUP_AND_NEXT_STEPS.md # CRITICAL: Detailed manual setup guide & next steps
├── lib/
│   ├── core/                     # Core utilities, services, and configurations
│   │   ├── auth/                 # Authentication (models, notifiers, providers, repositories, screens)
│   │   ├── localization/         # Internationalization setup (l10n files, generated code)
│   │   ├── routing/              # GoRouter configuration (app_router.dart)
│   │   ├── services/             # Service interfaces (Notification, Storage, Analytics) & providers
│   │   ├── theme/                # Theme definitions (theme.dart)
│   │   ├── user_settings/        # User settings (models, providers, repositories)
│   │   └── utils/                # Utility files (constants.dart, enums.dart)
│   │   └── widgets/              # Common reusable themed widgets (buttons, cards)
│   ├── features/                 # Feature-specific modules
│   │   ├── business/             # Business feature (models, providers, repositories) - Conceptual
│   │   ├── pet_profile/          # Pet Profile feature (models, providers, repositories, screens)
│   │   ├── reminders/            # Reminders feature (models, providers, repositories) - Conceptual
│   │   └── ... (other features planned)
│   ├── firebase_options.dart     # Generated by `flutterfire configure` (USER TASK)
│   └── main.dart                 # Main application entry point
├── l10n.yaml                     # Configuration for localization generation
├── pubspec.yaml                  # Project dependencies and metadata (includes TODOs for future packages)
└── README.md                     # This file
```
Platform-specific directories (`android/`, `ios/`, etc.) and test directories (`test/`, `integration_test/`) will be generated/populated when you run `flutter pub get` and `flutter create .`.

*(This README will be updated as the project progresses.)*
