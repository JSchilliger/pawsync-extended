// lib/core/user_settings/repositories/user_settings_repository.dart

import 'package:paw_sync/core/user_settings/models/user_settings_model.dart';

/// Abstract interface for a repository that manages user-specific settings.
abstract class UserSettingsRepository {
  /// Fetches the settings for a given user.
  /// Returns null if no settings are found for the user (e.g., new user).
  /// In such cases, default settings might be applied by the application.
  Future<UserSettingsModel?> getUserSettings(String userId);

  /// Creates or updates the settings for a given user.
  /// If settings for the user do not exist, they should be created.
  /// If they exist, they should be overwritten or merged.
  Future<void> updateUserSettings(UserSettingsModel settings);

  // Note: Deletion of user settings is typically tied to user account deletion,
  // which might be handled elsewhere or by a more general user data deletion process.
  // A specific deleteUserSettings method might not be needed here unless settings
  // can be "reset" to a non-existent state.
}

/// Custom exception for errors occurring in the UserSettingsRepository.
class UserSettingsRepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic underlyingException;

  UserSettingsRepositoryException(this.message, {this.code, this.underlyingException});

  @override
  String toString() {
    String result = 'UserSettingsRepositoryException: $message';
    if (code != null) {
      result += ' (Code: $code)';
    }
    if (underlyingException != null) {
      result += '\nUnderlying exception: $underlyingException';
    }
    return result;
  }
}
