// lib/features/business/repositories/business_repository.dart

import 'package:paw_sync/features/business/models/business_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // For GeoPoint if used in query parameters

/// Abstract interface for a repository that manages business data.
abstract class BusinessRepository {
  /// Fetches a list of businesses, potentially filtered by type, location, or other criteria.
  ///
  /// [type]: Optional filter by BusinessType.
  /// [latitude], [longitude], [radiusInKm]: Optional parameters for location-based search.
  /// Other filters like services offered could be added.
  Future<List<BusinessModel>> getBusinesses({
    BusinessType? type,
    // double? latitude, // Example for geo-queries
    // double? longitude,
    // double? radiusInKm,
    List<String>? services, // Filter by services offered
    // TODO: Add pagination parameters (e.g., lastDocumentSnapshot, limit)
  });

  /// Fetches a single business by its ID.
  /// Returns null if the business is not found.
  Future<BusinessModel?> getBusinessById(String businessId);

  /// Adds a new business.
  /// (Primarily an admin or business owner function)
  Future<void> addBusiness(BusinessModel business);

  /// Updates an existing business.
  /// (Primarily an admin or business owner function)
  Future<void> updateBusiness(BusinessModel business);

  /// Deletes a business by its ID.
  /// (Primarily an admin function)
  Future<void> deleteBusiness(String businessId);

  // TODO: Consider methods for fetching businesses owned by a specific user if `ownerUserId` is used.
  // Future<List<BusinessModel>> getBusinessesByOwner(String ownerUserId);

  // TODO: Consider methods for business reviews if reviews are part of this repository.
  // Future<void> addReview(String businessId, ReviewModel review);
  // Future<List<ReviewModel>> getReviews(String businessId, {int limit, DocumentSnapshot? startAfter});
  // Stream<List<ReviewModel>> getReviewsStream(String businessId, {int limit});
}

/// Custom exception for errors occurring in the BusinessRepository.
class BusinessRepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic underlyingException;

  BusinessRepositoryException(this.message, {this.code, this.underlyingException});

  @override
  String toString() {
    String result = 'BusinessRepositoryException: $message';
    if (code != null) {
      result += ' (Code: $code)';
    }
    if (underlyingException != null) {
      result += '\nUnderlying exception: $underlyingException';
    }
    return result;
  }
}
