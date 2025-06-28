# Paw Sync - Pet Lifecycle Management App

## Project Purpose

Paw Sync is a comprehensive, user-centric mobile application for pet owners (dogs, cats, NAC/exotic pets). It aims to serve as a complete lifecycle management platform for pets, connecting owners with essential services and information. The user experience will prioritize being clean, intuitive, and secure.

## IMPORTANT SETUP NOTE FOR USER:
Due to limitations with the automated tooling environment, the agent cannot reliably run `flutter create` or `flutter pub get` without encountering issues that roll back changes.

**After the agent completes the initial file and directory structure setup, YOU WILL NEED TO MANUALLY:**

1.  **Navigate to the `paw_sync` directory in your terminal.**
2.  **Run `flutter pub get`**. This will fetch all the necessary dependencies defined in `pubspec.yaml`, generate essential platform-specific files (like `Podfile`, Gradle files), the `.dart_tool` directory, and may also trigger `flutter gen-l10n`.
3.  **Run `flutter gen-l10n`** (if not automatically run by `flutter pub get` or if you update ARB files). This command reads `l10n.yaml` and your ARB files (e.g., `lib/core/localization/l10n/app_en.arb`) to generate/update the necessary Dart localization files (e.g., `app_localizations.dart` which `main.dart` imports).
4.  **Install FlutterFire CLI if you haven't already: `dart pub global activate flutterfire_cli`**
5.  **Run `flutterfire configure`** from the `paw_sync` directory. This command will guide you to select your Firebase project and will generate `lib/firebase_options.dart` which is crucial for initializing Firebase. Ensure you select the correct Firebase project and platforms (iOS, Android, Web if applicable).
6.  **If core platform directories (`android`, `ios`, `linux`, `macos`, `windows`, `web`) or other essential project files like `analysis_options.yaml` are missing after the previous steps, you might also need to run `flutter create . --project-name paw_sync` (note the dot) INSIDE the `paw_sync` directory.** This command will generate any missing platform-specific boilerplate and project files without overwriting your `lib` content, `pubspec.yaml`, or this `README.md` if they already exist with content.

The agent has written `lib/main.dart` to include Firebase initialization, theme setup, localization, and basic routing, expecting `firebase_options.dart` (from `flutterfire configure`) and generated localization files (from `flutter gen-l10n`) to be available after you complete these steps.

## Core Technologies & Architecture

This project is built using Flutter for cross-platform mobile development.

*   **State Management**: [Riverpod](https://riverpod.dev/) is used for all state management.
*   **Navigation**: [go_router](https://pub.dev/packages/go_router) manages all routing and navigation. All app routes are defined in `lib/core/routing/app_router.dart`.
*   **Backend**: Firebase is the chosen Backend-as-a-Service (BaaS) for Authentication, Cloud Firestore (database), and Firebase Cloud Storage (file storage).
*   **Project Structure**: A feature-first architecture is adopted.
*   **Internationalization (i18n)**: Uses `flutter_localizations` and `intl`. ARB files are in `lib/core/localization/l10n/` (e.g., `app_en.arb`, `app_fr.arb`). `l10n.yaml` configures string generation.
*   **Design System**: A central `theme.dart` file (`lib/core/theme/theme.dart`) defines the application's design system (colors, fonts, text styles).

## How to Run (After Manual Steps Above)

1.  **Ensure Flutter is installed:** Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
2.  **Complete the IMPORTANT SETUP NOTE FOR USER above.** (This includes running `flutter pub get`, `flutter gen-l10n`, `flutterfire configure`, and potentially `flutter create .` inside the `paw_sync` directory).
3.  **Set up Firebase (User Responsibility):**
    *   Ensure you have created a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/).
    *   Ensure you have registered your Flutter app for Android and iOS (and other platforms as needed) within your Firebase project.
    *   Download `google-services.json` (for Android) and place it in `paw_sync/android/app/`.
    *   Download `GoogleService-Info.plist` (for iOS) and place it in `paw_sync/ios/Runner/`.
    *   The `flutterfire configure` step (mentioned above) should handle `lib/firebase_options.dart`.
4.  **Run the app:**
    ```bash
    cd paw_sync
    flutter run
    ```
    (Specific run commands for different flavors or emulators/devices will be added later).

## Project Structure Overview

```
paw_sync/
├── AGENTS.md                # Instructions for AI agents working on this repo
├── lib/
│   ├── core/                # Core utilities, services, and configurations
│   │   ├── auth/            # Authentication logic, providers (partially exists or planned)
│   │   ├── localization/    # Internationalization setup
│   │   │   ├── l10n/        # ARB files (app_en.arb, app_fr.arb exist)
│   │   │   └── generated/   # Generated localization files (e.g., app_localizations.dart via flutter gen-l10n)
│   │   ├── routing/         # GoRouter configuration (app_router.dart exists)
│   │   └── theme/           # Theme definitions (theme.dart exists)
│   ├── features/            # Feature-specific modules (planned)
│   │   ├── pet_profile/     # Example feature (planned)
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── ... (other features)
│   ├── firebase_options.dart  # Generated by `flutterfire configure` (USER TASK)
│   └── main.dart            # Main application entry point (exists, configured)
├── l10n.yaml                # Configuration for localization generation (exists)
├── pubspec.yaml             # Project dependencies and metadata (exists)
└── README.md                # This file
```
Platform-specific directories (`android/`, `ios/`, etc.) and test directories (`test/`, `integration_test/`) will be generated/populated when you run `flutter pub get` and `flutter create .`.

*(This README will be updated as the project progresses.)*
