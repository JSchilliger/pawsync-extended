// lib/core/services/notification_service.dart

/// Abstract interface for a service that manages local and potentially push notifications.
///
/// This defines the contract for notification operations, allowing for different
/// implementations (e.g., using flutter_local_notifications, Firebase Messaging).
abstract class NotificationService {
  /// Initializes the notification service.
  /// This should be called once when the app starts, typically in main.dart.
  /// It might involve setting up notification channels (Android),
  /// and configuring foreground/background message handlers.
  Future<void> initialize();

  /// Requests notification permissions from the user, primarily for iOS and newer Android.
  /// Returns true if permissions are granted or already granted, false otherwise.
  Future<bool> requestPermissions();

  /// Schedules a local notification to be displayed at a specific time.
  ///
  /// [id]: A unique identifier for the notification.
  /// [title]: The title of the notification.
  /// [body]: The main content of the notification.
  /// [scheduledDate]: The date and time when the notification should appear.
  /// [payload]: Optional data to be passed along with the notification,
  ///            which can be retrieved when the user taps the notification.
  Future<void> scheduleLocalNotification({
    required int id, // Integer ID is common for flutter_local_notifications
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  });

  /// Shows a simple, immediate local notification.
  Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  });

  /// Cancels a specific scheduled or displayed notification by its ID.
  Future<void> cancelNotification(int id);

  /// Cancels all scheduled and displayed notifications.
  Future<void> cancelAllNotifications();

  /// Retrieves the payload from the notification that launched the app.
  /// Returns null if the app was not launched by a notification tap.
  Future<String?> getNotificationAppLaunchDetailsPayload();

  // TODO: Define methods for handling incoming push notifications if firebase_messaging is used.
  // e.g., Stream<RemoteMessage> get onPushMessageReceived;
  // e.g., Future<String?> getFcmToken();
  // e.g., Future<void> setupPushNotificationInteractions(); // For background/terminated taps

  // TODO: Define methods for user-specific notification preferences if needed.
  // e.g., Future<void> updateNotificationPreferences(UserNotificationPreferences preferences);
  // e.g., Future<UserNotificationPreferences> getNotificationPreferences();
}

/// Placeholder for user notification preferences, if needed later.
// class UserNotificationPreferences {
//   final bool allowGeneralNotifications;
//   final bool allowReminderNotifications;
//   // Add more specific preferences as needed
//
//   UserNotificationPreferences({
//     this.allowGeneralNotifications = true,
//     this.allowReminderNotifications = true,
//   });
// }
