# Paw Sync: Manual Setup, V1 Status, and Next Steps Guide

This document provides essential manual setup instructions to get the Paw Sync Flutter application running. It also outlines the V1 development status, key remaining placeholders, and potential future development directions.

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
    *   **Important:** When prompted, ensure you select the correct Firebase project and register the app for the platforms you intend to support (iOS, Android, Web, etc.). Don't forget to add SHA-1 keys for Android for Google Sign-In to work.

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
        *   **Authentication:** Email/Password and Google Sign-In must be enabled. For Google Sign-In, you'll need to configure OAuth consent screen and provide SHA-1 fingerprints for Android in your Firebase project settings.
        *   **Cloud Firestore:** (Database). Create a Firestore database and set up security rules (e.g., start in test mode, then refine).
        *   **Cloud Storage for Firebase:** (File storage). Set up storage and security rules. This will be needed for pet photo uploads.

## 3. V1 Application Status (As of [Current Date - User to fill])

The application has reached a V1 milestone with the following core features implemented:

*   **Core Architecture:**
    *   **State Management:** Riverpod is used for managing state, with providers for repositories, services (API only), and notifiers (`AuthNotifier`).
    *   **Navigation:** GoRouter handles navigation, including a basic error page for unknown routes.
    *   **Theming:** A base theme is defined.
    *   **Localization:** Setup for English and French.
    *   **Models:** Core data models (`UserModel`, `PetModel` with sub-models, `BusinessModel`, `ReminderModel`, `UserSettingsModel`) are defined.
    *   **Repositories:** `AuthRepository` and `PetRepository` have Firebase implementations. Others are API-only.

*   **Implemented Features (V1):**
    *   **User Authentication:**
        *   Sign Up with Email/Password.
        *   Login with Email/Password.
        *   Login with Google.
        *   Password Reset via email.
        *   Logout.
    *   **Pet Management (CRUD):**
        *   **Create:** Add new pets with basic details (name, species, breed, birth date, photo URL via text input).
        *   **Read (List):** View a list of the current user's pets on the "My Pets" screen, with real-time updates from Firestore. Handles loading, error, and empty states.
        *   **Read (Details):** View a detailed screen for each pet, showing all its information (including photo if URL provided).
        *   **Update:** Edit the basic details of an existing pet.
        *   **Delete:** Delete pets with a confirmation dialog.
    *   **Basic Placeholders:**
        *   A placeholder "Notifications" screen is accessible from the "My Pets" screen.

## 4. Key Remaining Placeholders & Future Enhancements

While V1 is functional, many areas are placeholders or have TODOs for future development:

*   **Pet Profile Feature Completeness:**
    *   **Image Picking/Uploading:** Implement pet photo uploads using `image_picker` and `firebase_storage` (currently a text input for URL).
    *   **Detailed Data Management for Pets:** The "Add/Edit Pet" screen currently handles basic fields. Future work includes UI and logic for managing:
        *   Vaccination Records (add, edit, delete individual records).
        *   Medical History events (add, edit, delete events, handle attachments).
        *   Grooming Preferences (dedicated UI for these fields).
        *   Behavior Profile (dedicated UI for these fields).
*   **Notifications Feature:**
    *   Implement actual notification functionality (local and/or push via Firebase Cloud Messaging) to replace the placeholder screen.
    *   Connect to `NotificationService`.
*   **User Settings Feature:**
    *   Create a UI for managing user settings (e.g., notification preferences, theme choice).
    *   Implement `UserSettingsRepository` (Firebase).
    *   Develop a `UserSettingsNotifier`.
*   **Business Listings & Management Feature (Major Area):**
    *   Implement `BusinessRepository` (Firebase) with features like search, pagination, reviews.
    *   Develop UI screens for discovering, viewing, and potentially managing businesses.
    *   Create `BusinessNotifier`.
*   **Reminders Feature (Major Area):**
    *   Implement `ReminderRepository` (Firebase).
    *   Develop UI screens for creating, viewing, and managing reminders (e.g., for vaccinations, appointments).
    *   Integrate with local notifications.
    *   Create `ReminderNotifier`.
*   **Service Implementations:**
    *   Provide concrete Firebase implementations for `AnalyticsService` and `StorageService`.
*   **UI/UX Polish & Enhancements:**
    *   Implement Dark Theme and theme switching.
    *   Improve form inputs (e.g., dropdown for pet species).
    *   Enhance error messages to be more user-friendly.
    *   Add actual image assets for placeholders (e.g., default pet photo).
*   **Technical Debt & Refinements:**
    *   Address `pubspec.yaml` TODOs for future dependencies (e.g., maps, advanced phone input, `freezed` for models).
    *   Write comprehensive unit, widget, and integration tests.
    *   Review and enhance Firebase Security Rules for production.
    *   Address platform-specific build TODOs (Android signing, etc.).

## 5. Potential Next Development Steps (Post-V1)

Based on the V1 status, logical next steps could include:

1.  **Full Pet Profile Management:**
    *   Implement image uploading for pet photos.
    *   Build UI for adding/editing detailed pet sub-records (vaccinations, medical history, grooming, behavior).
2.  **Core Feature Implementation - Reminders:**
    *   Develop the reminder creation, listing, and notification logic. This is a high-value feature for pet owners.
3.  **Core Feature Implementation - Business Listings (Basic):**
    *   Start with displaying a list of businesses (if data source exists or is mocked/manually populated in Firebase).
    *   Allow viewing business details.
4.  **User Settings:**
    *   Implement a basic user settings screen (e.g., for notification preferences if notifications are being worked on).
5.  **UI/UX Polish:**
    *   Implement Dark Theme.
    *   Improve form usability (e.g., species dropdown).
6.  **Testing and Robustness:**
    *   Increase test coverage.
    *   Strengthen Firebase security rules.

Prioritization will depend on user feedback and project goals.

## 6. Conceptual Error Handling Strategy (General Guide)

(This section can largely remain as is from the previous version, as it's general guidance)
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

## 7. UI Style and Theming Decisions (General Guide)

(This section can also largely remain as is, as it describes the established style)
*   **Color Palette:** Aims for a **pastel and less "pop"** base (Muted Blue/Lavender primary, Softer Teal secondary), with a vibrant `highlight` color for CTAs. See `lib/core/theme/theme.dart` (`AppColors`).
*   **Typography:** Uses 'Roboto' (default) and 'RobotoSlab' (headings) as placeholders. `TextTheme` in `theme.dart` maps to Material Design scale.
*   **Custom Themed Widgets:**
    *   Buttons: `PrimaryActionButton`, `SecondaryActionButton`, `DestructiveActionButton` in `lib/core/widgets/themed_buttons.dart`.
    *   Cards: `StyledCard` in `lib/core/widgets/styled_card.dart`.
*   **Iconography:** Currently Material Icons. Custom icons can be considered.

---

This guide should help you bridge the gap between the agent-generated code and a runnable, developable application state. Remember to commit your local changes (like `firebase_options.dart` and platform config files) to your version control system.
