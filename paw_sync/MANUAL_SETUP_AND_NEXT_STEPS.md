# Paw Sync: Manual Setup, Current Status, and Next Steps Guide

This document provides essential manual setup instructions to get the Paw Sync Flutter application running after the codebase has been generated or updated by an automated agent. It also outlines the current development status, key placeholders, and potential next steps.

## 1. Essential Manual Setup Commands

Due to limitations in automated environments, several crucial steps MUST be performed manually in your local development environment.

**Execute these commands in your terminal, inside the `paw_sync` project directory:**

1.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
    *   **Why?** This fetches all necessary packages defined in `pubspec.yaml` (like Riverpod, GoRouter, Firebase SDKs, etc.) and creates the `.dart_tool/` directory and platform-specific lockfiles. The application will not compile without this.

2.  **Generate Localization Files:**
    ```bash
    flutter gen-l10n
    ```
    *   **Why?** This command reads `l10n.yaml` and your ARB files (e.g., `lib/core/localization/l10n/app_en.arb`) to generate the Dart localization files (e.g., `app_localizations.dart`) which `main.dart` and other UI components import for localized strings. This might run automatically with `flutter pub get` in some setups, but running it manually ensures it's done.

3.  **Install FlutterFire CLI (if not already installed):**
    ```bash
    dart pub global activate flutterfire_cli
    ```
    *   **Why?** The FlutterFire CLI is used to connect your Flutter app to your Firebase project.

4.  **Configure Firebase for your Flutter app:**
    ```bash
    flutterfire configure
    ```
    *   **Why?** This is a critical step. It will:
        *   Guide you to select your Firebase project (see Section 2 below).
        *   Automatically generate `lib/firebase_options.dart`, which is essential for initializing Firebase in `main.dart`.
        *   Help set up platform-specific Firebase configurations (though you might still need to manually add downloaded config files for existing projects - see Section 2.2).
    *   **Important:** When prompted, ensure you select the correct Firebase project and register the app for the platforms you intend to support (iOS, Android, Web, etc.).

5.  **Generate Missing Platform Files (If Necessary):**
    If core platform directories (`android`, `ios`, `linux`, `macos`, `windows`, `web`) or other essential project files (like `analysis_options.yaml`) seem to be missing or incomplete after the previous steps, run:
    ```bash
    flutter create . --project-name paw_sync
    ```
    *   **Note the dot `.`**: This command should be run *inside* the `paw_sync` directory.
    *   **Why?** This regenerates any missing platform-specific boilerplate and project files without overwriting your `lib/` content, `pubspec.yaml`, or `README.md` if they already exist with content.

## 2. Firebase Project Setup (User Responsibility)

Before running `flutterfire configure`, you need a Firebase project.

1.  **Create a Firebase Project:**
    *   Go to the [Firebase Console](https://console.firebase.google.com/).
    *   Click "Add project" and follow the instructions to create a new project or select an existing one.

2.  **Platform-Specific Configuration Files (Especially for existing Firebase projects):**
    *   While `flutterfire configure` handles much of the setup, ensure the following files are correctly placed if you're integrating with an existing Firebase project or if `flutterfire configure` doesn't place them for some reason:
        *   **Android:** Download `google-services.json` from your Firebase project settings (Project Settings > General > Your apps > Android app). Place it in `paw_sync/android/app/`.
        *   **iOS:** Download `GoogleService-Info.plist` from your Firebase project settings. Place it in `paw_sync/ios/Runner/`.
    *   `flutterfire configure` should ideally handle `lib/firebase_options.dart`.

3.  **Enable Firebase Services:**
    *   In the Firebase Console, ensure you have enabled the necessary services for Paw Sync:
        *   **Authentication:** (e.g., Email/Password, Google Sign-In). For Google Sign-In, you'll need to configure OAuth consent screen and provide SHA-1 fingerprints for Android.
        *   **Cloud Firestore:** (Database). Create a Firestore database and set up security rules (e.g., start in test mode, then refine).
        *   **Cloud Storage for Firebase:** (File storage). Set up storage and security rules.

## 3. Current Codebase Status & Key Placeholders

The agent has set up a foundational structure. Here's a summary of what's in place and what needs attention:

*   **Core Architecture:**
    *   **State Management:** Riverpod is set up with providers for repositories, services, and notifiers (e.g., `AuthNotifier`).
    *   **Navigation:** GoRouter is configured with basic routes in `lib/core/routing/app_router.dart`.
    *   **Theming:** A theme is defined in `lib/core/theme/theme.dart` with a pastel color palette, typography scale, and some component themes. Custom themed widgets (`themed_buttons.dart`, `styled_card.dart`) exist.
    *   **Localization:** Setup for English and French using `.arb` files and `flutter_localizations`.
    *   **Models:** `UserModel`, `PetModel` (with `VaccinationRecord`, `MedicalEvent`, `GroomingPreferences`, `BehaviorProfile`), `BusinessModel` (with `OperatingHours`), `ReminderModel`, `UserSettingsModel` are defined.
    *   **Repositories:** Interfaces (`AuthRepository`, `PetRepository`, `BusinessRepository`, `ReminderRepository`, `UserSettingsRepository`) and Firebase implementations (`FirebaseAuthRepository`, `FirebasePetRepository`) are defined. Others are API-only.
    *   **Services:** Interfaces (`NotificationService`, `StorageService`, `AnalyticsService`) are defined with API-only providers.
    *   **Utilities:** Centralized `enums.dart` and `constants.dart` (for Firestore collection names) are in place.

*   **Key Placeholders & TODOs:**
    *   **`signInWithGoogle()` in `FirebaseAuthRepository`:**
        *   **File:** `lib/core/auth/repositories/firebase_auth_repository.dart`
        *   **Issue:** Currently throws `UnimplementedError`.
        *   **Action:** Requires adding the `google_sign_in` package (see `pubspec.yaml` TODOs), running `flutter pub get`, implementing logic, and platform-specific Firebase/Google Cloud setup.
    *   **Image Assets:**
        *   **Files:** `login_screen.dart`, `pet_profile_screen.dart` reference placeholder image assets (e.g., `assets/images/google_logo.png`, `assets/images/dog_placeholder.png`).
        *   **Issue:** These asset files do not exist.
        *   **Action:** Create `assets/images/`, add images, declare in `pubspec.yaml` (see commented examples), and run `flutter pub get`.
    *   **Notifier Implementations (Beyond AuthNotifier):**
        *   While `AuthNotifier` is drafted, notifiers for other features (Pet Profiles, Reminders, Businesses, UserSettings) need to be created to manage their respective states and business logic.
    *   **Repository Implementations (Beyond Auth & Pet):**
        *   `BusinessRepository`, `ReminderRepository`, `UserSettingsRepository` have API-only providers. Concrete Firebase (or other) implementations need to be written.
    *   **Service Implementations:**
        *   `NotificationService`, `StorageService`, `AnalyticsService` have API-only providers. Concrete implementations are needed.
    *   **UI to Logic Connection:**
        *   Most UI screens (`LoginScreen`, `PetProfileScreen`, etc.) are static placeholders. They need to be connected to Riverpod providers and notifiers to display real data and handle user interactions.
    *   **Review General TODOs:** Search the codebase for "TODO:" comments for other specific items.

## 4. Potential Next Development Steps (After Manual Setup)

Once the manual setup is complete and the app can compile and run with Firebase connected:

1.  **Implement `signInWithGoogle` fully.**
2.  **Add image assets and verify they load.**
3.  **Develop Notifiers/Controllers:** Implement `AsyncNotifier` or `StateNotifier` classes for Pet Profiles, Reminders, Businesses, UserSettings, etc.
4.  **Implement Remaining Repositories:** Provide Firebase implementations for `BusinessRepository`, `ReminderRepository`, `UserSettingsRepository`.
5.  **Implement Services:** Provide concrete implementations for `NotificationService`, `StorageService`, `AnalyticsService`.
6.  **Connect UI to Logic:**
    *   Refactor UI screens to be `ConsumerWidget` or use `Consumer`s.
    *   Fetch and display data from providers/notifiers.
    *   Wire up buttons and forms to call methods on notifiers/providers.
7.  **Build out UI for other features** as per the project plan (e.g., Add/Edit Pet screen, Pet Detail screen, Reminder creation, Business listings).
8.  **Implement Navigation:** Refine GoRouter setup, ensure navigation between screens works as expected. Uncomment and implement the auth redirect logic in `app_router.dart` using `AuthNotifier` state.
9.  **Testing:** Write unit, widget, and integration tests for new logic and UI.
10. **Security Rules:** Implement robust Firebase security rules for Firestore and Storage.

## 5. Conceptual Error Handling Strategy

A consistent approach to error handling improves user experience and maintainability.

*   **Repository Exceptions:** Custom exceptions like `AuthRepositoryException`, `PetRepositoryException`, etc., wrap underlying errors.
*   **Notifier/State Management:** `AsyncNotifier` and `AsyncValue` are used to manage loading, data, and error states. UI uses `state.when()` for display.
*   **User-Friendly Messages:** Plan for a utility to map error codes/types to localized, user-friendly messages.
*   **Error Presentation in UI:**
    *   **Inline Form Errors:** For validation.
    *   **SnackBars/Toasts:** For non-critical errors/confirmations.
    *   **Dialogs:** For critical errors.
    *   **Full Screen Error States:** For failed primary data fetches (with retry options).
    *   **Loading Indicators:** Clearly indicate loading states.
*   **Global Error Handling/Logging:** Consider `PlatformDispatcher.instance.onError` and integration with crash reporting (e.g., Firebase Crashlytics).
*   **Specific Scenarios:** Plan for network issues, Firebase errors, validation errors, etc.

## 6. UI Style and Theming Decisions (Conceptual)

*   **Color Palette:** Aims for a **pastel and less "pop"** base (Muted Blue/Lavender primary, Softer Teal secondary), with a vibrant `highlight` color for CTAs. See `lib/core/theme/theme.dart` (`AppColors`).
*   **Typography:** Uses 'Roboto' (default) and 'RobotoSlab' (headings) as placeholders. `TextTheme` in `theme.dart` maps to Material Design scale.
*   **Custom Themed Widgets:**
    *   Buttons: `PrimaryActionButton`, `SecondaryActionButton`, `DestructiveActionButton` in `lib/core/widgets/themed_buttons.dart`.
    *   Cards: `StyledCard` in `lib/core/widgets/styled_card.dart`.
*   **Iconography:** Currently Material Icons. Custom icons can be considered.

---

This guide should help you bridge the gap between the agent-generated code and a runnable, developable application state. Remember to commit your local changes (like `firebase_options.dart` and platform config files) to your version control system.
