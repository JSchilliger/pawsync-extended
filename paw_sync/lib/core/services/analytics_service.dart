// lib/core/services/analytics_service.dart

/// Abstract interface for an analytics service.
///
/// This allows for plugging in different analytics backends (e.g., Firebase Analytics,
/// Mixpanel, Amplitude) by creating concrete implementations of this service.
abstract class AnalyticsService {
  /// Logs an analytics event.
  ///
  /// [name]: The name of the event (e.g., 'button_click', 'screen_view', 'pet_added').
  ///         It's good practice to use snake_case for event names.
  /// [parameters]: Optional. A map of key-value pairs providing additional
  ///               context for the event. Values can be String, num, or bool.
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  });

  /// Sets a user identifier for the current session.
  ///
  /// [userId]: The unique identifier for the user.
  Future<void> setUserIdentifier(String userId);

  /// Sets a user property.
  ///
  /// [name]: The name of the user property (e.g., 'user_tier', 'has_active_subscription').
  /// [value]: The value of the user property (String).
  Future<void> setUserProperty({
    required String name,
    required String value, // Firebase Analytics user properties are String
  });

  /// Logs a screen view event.
  ///
  /// [screenName]: The name of the screen being viewed.
  /// [screenClassOverride]: Optional. The name of the screen class, if different from `screenName`.
  ///                        Useful for platforms like Firebase Analytics.
  Future<void> setCurrentScreen({
    required String screenName,
    String? screenClassOverride, // Typically the Widget name for Firebase Analytics
  });

  // TODO: Consider methods for e-commerce tracking if applicable.
  // TODO: Consider methods for error reporting integration if not handled separately.
}

/// Custom exception for errors occurring in the AnalyticsService.
/// Though analytics errors are often "fire and forget" and might not always
/// need to surface to the user, having an exception type can be useful for
/// logging or debugging issues with the analytics integration itself.
class AnalyticsServiceException implements Exception {
  final String message;
  final dynamic underlyingException;

  AnalyticsServiceException(this.message, [this.underlyingException]);

  @override
  String toString() {
    String result = 'AnalyticsServiceException: $message';
    if (underlyingException != null) {
      result += '\nUnderlying exception: $underlyingException';
    }
    return result;
  }
}
