// lib/core/services/service_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/core/services/notification_service.dart';

// Provider for the NotificationService implementation.
// Concrete implementation (e.g., LocalNotificationService) will be provided here.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  // In a real application, you would return an instance of a concrete implementation:
  // Example for local notifications:
  // final service = LocalNotificationServiceImpl(); // Assuming LocalNotificationServiceImpl implements NotificationService
  // service.initialize(); // It's common to initialize here or ensure it's initialized early.
  // return service;

  // For now, it throws UnimplementedError as per "API-only" definition.
  throw UnimplementedError(
      'NotificationService implementation not provided yet. This is an API-only definition.');
});
