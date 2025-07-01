// lib/core/services/storage_service.dart
import 'dart:io'; // Required for File type

/// Abstract interface for a service that handles file storage operations.
///
/// This defines the contract for file storage, allowing for different
/// implementations (e.g., Firebase Storage, local storage for testing).
abstract class StorageService {
  /// Uploads a pet's profile image to the storage.
  ///
  /// - [imageFile]: The image file to upload.
  /// - [userId]: The ID of the user who owns the pet.
  /// - [petId]: The ID of the pet for whom the image is being uploaded.
  /// - [fileName]: A specific name for the file in storage (e.g., 'profile_photo.jpg').
  ///             If null, a unique name might be generated or a default used.
  ///
  /// Returns the download URL of the uploaded image.
  /// Throws a [StorageServiceException] if an error occurs.
  Future<String> uploadPetProfileImage({
    required File imageFile,
    required String userId,
    required String petId,
    required String fileName, // Making fileName required for a predictable path
  });

  /// Deletes a pet's profile image from storage.
  ///
  /// - [userId]: The ID of the user who owns the pet.
  /// - [petId]: The ID of the pet whose image is being deleted.
  /// - [fileName]: The specific name of the file in storage.
  ///
  /// Throws a [StorageServiceException] if an error occurs.
  Future<void> deletePetProfileImage({
    required String userId,
    required String petId,
    required String fileName,
  });

  // TODO: Add other methods as needed, e.g.:
  // - uploadDocument(File file, String path)
  // - deleteFile(String fullPath)
}

/// Custom exception for errors occurring in the StorageService.
class StorageServiceException implements Exception {
  final String message;
  final dynamic underlyingException;

  StorageServiceException(this.message, {this.underlyingException});

  @override
  String toString() {
    String result = 'StorageServiceException: $message';
    if (underlyingException != null) {
      result += '\nUnderlying exception: $underlyingException';
    }
    return result;
  }
}
