// lib/core/services/service_providers.dart
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/core/services/storage_service.dart';
import 'package:paw_sync/core/services/firebase_storage_service.dart';

// TODO: Add providers for AnalyticsService and NotificationService when their implementations are ready.

// Provider for FirebaseStorage instance
final firebaseStorageInstanceProvider = Provider<firebase_storage.FirebaseStorage>((ref) {
  return firebase_storage.FirebaseStorage.instance;
});

// Provider for the StorageService implementation
final storageServiceProvider = Provider<StorageService>((ref) {
  final firebaseStorage = ref.watch(firebaseStorageInstanceProvider);
  return FirebaseStorageService(firebaseStorage);
});
