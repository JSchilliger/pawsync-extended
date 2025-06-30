// lib/core/user_settings/models/user_settings_model.dart

import 'package:flutter/foundation.dart';
import 'package:paw_sync/core/utils/enums.dart'; // Import centralized enums

@immutable
class UserSettingsModel {
  final String userId; // Document ID should be the user's UID
  final ThemePreference themePreference;
  final String languagePreference; // e.g., 'en', 'fr'
  final bool receivePushNotifications; // General toggle for all push notifications
  final bool receiveEmailUpdates;   // For newsletters, updates etc.

  // TODO: Add more specific notification preferences if needed, e.g.:
  // final bool reminderPushNotifications;
  // final bool socialPushNotifications; (if a social feature is added)

  const UserSettingsModel({
    required this.userId,
    this.themePreference = ThemePreference.system,
    this.languagePreference = 'en', // Default language
    this.receivePushNotifications = true,
    this.receiveEmailUpdates = false, // Default to opt-out for marketing-type emails
  });

  UserSettingsModel copyWith({
    String? userId,
    ThemePreference? themePreference,
    String? languagePreference,
    bool? receivePushNotifications,
    bool? receiveEmailUpdates,
  }) {
    return UserSettingsModel(
      userId: userId ?? this.userId,
      themePreference: themePreference ?? this.themePreference,
      languagePreference: languagePreference ?? this.languagePreference,
      receivePushNotifications: receivePushNotifications ?? this.receivePushNotifications,
      receiveEmailUpdates: receiveEmailUpdates ?? this.receiveEmailUpdates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // userId is typically the document ID, so not always stored inside the document itself
      // 'userId': userId,
      'themePreference': themePreferenceToString(themePreference),
      'languagePreference': languagePreference,
      'receivePushNotifications': receivePushNotifications,
      'receiveEmailUpdates': receiveEmailUpdates,
    };
  }

  factory UserSettingsModel.fromJson(Map<String, dynamic> json, String userId) {
    // userId is passed in because it's the document ID, not part of the JSON map itself
    return UserSettingsModel(
      userId: userId,
      themePreference: themePreferenceFromString(json['themePreference'] as String? ?? ThemePreference.system.name),
      languagePreference: json['languagePreference'] as String? ?? 'en',
      receivePushNotifications: json['receivePushNotifications'] as bool? ?? true,
      receiveEmailUpdates: json['receiveEmailUpdates'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'UserSettingsModel(userId: $userId, themePreference: $themePreference, languagePreference: $languagePreference, receivePushNotifications: $receivePushNotifications, receiveEmailUpdates: $receiveEmailUpdates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSettingsModel &&
        other.userId == userId &&
        other.themePreference == themePreference &&
        other.languagePreference == languagePreference &&
        other.receivePushNotifications == receivePushNotifications &&
        other.receiveEmailUpdates == receiveEmailUpdates;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        themePreference.hashCode ^
        languagePreference.hashCode ^
        receivePushNotifications.hashCode ^
        receiveEmailUpdates.hashCode;
  }
}
