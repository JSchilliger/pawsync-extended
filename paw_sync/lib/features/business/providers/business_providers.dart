// lib/features/business/providers/business_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // For FirebaseFirestore if needed directly by repo provider
import 'package:paw_sync/features/business/repositories/business_repository.dart';
// Import concrete implementation when available, e.g.:
// import 'package:paw_sync/features/business/repositories/firebase_business_repository.dart';

// Provider for the BusinessRepository implementation.
// Concrete implementation (e.g., FirebaseBusinessRepository) will be provided here.
final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  // In a real application, you would return an instance of a concrete implementation:
  // final firestore = ref.watch(firebaseFirestoreProvider); // Assuming a global firestoreProvider
  // return FirebaseBusinessRepository(firestore);

  // For now, it throws UnimplementedError as per "API-only" definition.
  throw UnimplementedError(
      'BusinessRepository implementation not provided yet. This is an API-only definition.');
});

// TODO: Add other providers related to businesses as needed, for example:
// - Provider to fetch all businesses (or filtered list)
//   final businessesProvider = FutureProvider.autoDispose<List<BusinessModel>>((ref) {
//     return ref.watch(businessRepositoryProvider).getBusinesses();
//   });
//
// - Family provider for businesses by type:
//   final businessesByTypeProvider = FutureProvider.autoDispose.family<List<BusinessModel>, BusinessType>((ref, type) {
//     return ref.watch(businessRepositoryProvider).getBusinesses(type: type);
//   });
//
// - Provider for a single business details:
//   final businessDetailsProvider = FutureProvider.autoDispose.family<BusinessModel?, String>((ref, businessId) {
//     return ref.watch(businessRepositoryProvider).getBusinessById(businessId);
//   });
