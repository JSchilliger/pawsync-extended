// lib/core/user_settings/providers/user_settings_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/core/user_settings/models/user_settings_model.dart';
import 'package:paw_sync/core/user_settings/repositories/user_settings_repository.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart'; // For currentUserIdProvider or similar

// Provider for the UserSettingsRepository implementation.
final userSettingsRepositoryProvider = Provider<UserSettingsRepository>((ref) {
  // Example for Firebase implementation:
  // final firestore = ref.watch(firebaseFirestoreProvider); // Assuming global firestoreProvider
  // return FirebaseUserSettingsRepository(firestore);

  throw UnimplementedError(
      'UserSettingsRepository implementation not provided yet. This is an API-only definition.');
});

// Provider to fetch the current user's settings.
// It depends on the current user's ID.
final userSettingsProvider = FutureProvider.autoDispose<UserSettingsModel?>((ref) async {
  final currentUser = ref.watch(currentUserProvider); // From auth_providers.dart
  final userId = currentUser?.uid;

  if (userId == null) {
    // No user logged in, or user ID is not available.
    // Return null or default settings, or throw an error if settings are critical.
    // For now, returning null is a common approach. The UI would then handle this.
    return null;
  }

  final repository = ref.watch(userSettingsRepositoryProvider);
  final settings = await repository.getUserSettings(userId);

  if (settings == null) {
    // No settings found in the repository for this user, return default settings.
    // The repository itself could also return defaults, or it can be handled here.
    // This ensures the UI always has some UserSettingsModel to work with if a user is logged in.
    return UserSettingsModel(userId: userId); // Default settings with the correct userId
  }
  return settings;
});

// TODO: Consider adding a StateNotifier or AsyncNotifier for managing UserSettings
// if more complex logic or optimistic updates are needed when changing settings.
// For example:
// final userSettingsNotifierProvider = StateNotifierProvider<UserSettingsNotifier, AsyncValue<UserSettingsModel?>>((ref) {
//   return UserSettingsNotifier(ref);
// });
//
// class UserSettingsNotifier extends StateNotifier<AsyncValue<UserSettingsModel?>> {
//   final Ref _ref;
//   UserSettingsNotifier(this._ref) : super(const AsyncValue.loading()) {
//     _loadSettings();
//   }
//
//   Future<void> _loadSettings() async {
//     final userId = _ref.read(currentUserProvider)?.uid;
//     if (userId == null) {
//       state = const AsyncValue.data(null);
//       return;
//     }
//     try {
//       final settings = await _ref.read(userSettingsRepositoryProvider).getUserSettings(userId);
//       state = AsyncValue.data(settings ?? UserSettingsModel(userId: userId));
//     } catch (e, s) {
//       state = AsyncValue.error(e, s);
//     }
//   }
//
//   Future<void> updateTheme(ThemePreference newTheme) async {
//     final currentSettings = state.value;
//     if (currentSettings == null) return; // Should not happen if user is logged in
//
//     final updatedSettings = currentSettings.copyWith(themePreference: newTheme);
//     state = AsyncValue.data(updatedSettings); // Optimistic update
//
//     try {
//       await _ref.read(userSettingsRepositoryProvider).updateUserSettings(updatedSettings);
//     } catch (e, s) {
//       state = AsyncValue.data(currentSettings); // Revert optimistic update on error
//       // Optionally re-throw or handle error for UI
//     }
//   }
//   // Add other update methods for language, notification preferences etc.
// }
