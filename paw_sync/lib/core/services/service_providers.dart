// lib/core/services/service_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/core/services/notification_service.dart';
import 'package:paw_sync/core/services/storage_service.dart';
import 'package:paw_sync/core/services/analytics_service.dart'; // Import AnalyticsService

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

// Provider for the StorageService implementation.
final storageServiceProvider = Provider<StorageService>((ref) {
  // Example for Firebase Storage implementation:
  // final firebaseStorageInstance = ref.watch(firebaseStorageProvider); // Assuming global firebaseStorageProvider
  // return FirebaseStorageService(firebaseStorageInstance);

  throw UnimplementedError(
    'StorageService implementation not provided yet. This is an API-only definition.');
});

// Provider for the AnalyticsService implementation.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  // Example for Firebase Analytics implementation:
  // return FirebaseAnalyticsService(FirebaseAnalytics.instance); // Assuming FirebaseAnalyticsService and FirebaseAnalytics global provider

  throw UnimplementedError(
    'AnalyticsService implementation not provided yet. This is an API-only definition.');
});
