# Paw Sync: Manual Setup and Next Steps Guide

This document provides essential manual setup instructions to get the Paw Sync Flutter application running after the codebase has been generated or updated by an automated agent. It also outlines key placeholders and potential next steps in development.

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

## 3. Key Placeholders & TODOs in the Current Codebase

The agent has set up a foundational structure, but some parts require further attention:

*   **`signInWithGoogle()` in `FirebaseAuthRepository`:**
    *   **File:** `paw_sync/lib/core/auth/repositories/firebase_auth_repository.dart`
    *   **Issue:** Currently throws `UnimplementedError`.
    *   **Action:** Requires adding the `google_sign_in` package to `pubspec.yaml`, running `flutter pub get`, and then implementing the Google Sign-In logic. This also involves platform-specific setup in Firebase and your Flutter app (SHA-1 fingerprints for Android, URL schemes for iOS).

*   **`currentUserIdProvider` Connection:**
    *   **File:** `paw_sync/lib/features/pet_profile/providers/pet_providers.dart`
    *   **Issue:** Currently a placeholder returning `null`.
    *   **Action:** Connect this provider to the actual authentication state. For example, by watching `currentUserModelProvider` from `auth_providers.dart` and returning the user's UID. This is crucial for pet profile features to work correctly for the logged-in user.
    ```dart
    // Example of how to connect it:
    // final currentUserIdProvider = Provider<String?>((ref) {
    //   final userModel = ref.watch(currentUserModelProvider); // from core/auth/providers/auth_providers.dart
    //   return userModel?.uid;
    // });
    ```

*   **Image Assets:**
    *   **Files:** `login_screen.dart`, `pet_profile_screen.dart` reference placeholder image assets (e.g., `assets/images/google_logo.png`, `assets/images/dog_placeholder.png`).
    *   **Issue:** These asset files do not exist in the repository yet.
    *   **Action:**
        1.  Create an `assets/images/` directory in `paw_sync/`.
        2.  Add the required image files to this directory.
        3.  Declare the assets folder in `pubspec.yaml`:
            ```yaml
            flutter:
              uses-material-design: true
              assets:
                - assets/images/ # Add this line
            ```
        4.  Run `flutter pub get`.

*   **State Management with Notifiers:**
    *   **Files:** `auth_providers.dart`, `pet_providers.dart` (comments within).
    *   **Issue:** Current mutation providers (e.g., `addPetProvider`, `emailPasswordSignInProvider`) are basic.
    *   **Action:** Consider refactoring to use `AsyncNotifier` or `StateNotifier` for more robust state management, including handling loading and error states explicitly for UI feedback. Examples are commented out in the provider files.

*   **Review TODOs:**
    *   Search the codebase for "TODO:" comments. These mark areas where specific logic, navigation, or error handling needs to be implemented or refined.

## 4. Potential Next Development Steps (After Manual Setup)

Once the manual setup is complete and the app can compile and run with Firebase connected:

1.  **Implement `signInWithGoogle` fully.**
2.  **Connect `currentUserIdProvider` properly.**
3.  **Add image assets and verify they load.**
4.  **Develop Notifiers/Controllers:** Implement `AsyncNotifier` or `StateNotifier` classes for authentication and pet profile features to manage state and business logic.
5.  **Connect UI to Logic:**
    *   Replace `print()` statements in UI screen `onPressed` handlers with calls to your Notifiers or mutation providers.
    *   Use `ConsumerWidget` or `Consumer` to listen to providers and rebuild UI based on state changes (e.g., display pet lists, show loading indicators, handle errors).
6.  **Build out UI for other features** as per the project plan (e.g., Add/Edit Pet screen, Pet Detail screen).
7.  **Implement Navigation:** Refine GoRouter setup, ensure navigation between screens works as expected (e.g., from login to home, to add pet screen, etc.). Uncomment and implement the auth redirect logic in `app_router.dart`.
8.  **Testing:** Write unit, widget, and integration tests.
9.  **Security Rules:** Implement robust Firebase security rules for Firestore and Storage.

---

This guide should help you bridge the gap between the agent-generated code and a runnable, developable application state. Remember to commit your local changes (like `firebase_options.dart` and platform config files) to your version control system.
