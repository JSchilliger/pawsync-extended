// lib/core/services/storage_service.dart

import 'dart:typed_data'; // For Uint8List if handling web file data
// import 'dart:io'; // For File if handling mobile file data - commented out for interface

/// Abstract interface for a service that manages file uploads and deletions,
/// typically to a cloud storage solution like Firebase Cloud Storage.
abstract class StorageService {
  /// Uploads file data to the specified cloud storage path.
  ///
  /// [fileData]: The actual file data. This is `dynamic` to accommodate
  ///             platform differences (e.g., `File` on mobile, `Uint8List` or `html.File` on web).
  ///             The concrete implementation will handle the specific type.
  /// [path]: The full path in cloud storage where the file should be stored
  ///         (e.g., 'user_avatars/userId.jpg', 'pet_photos/petId/imageName.png').
  /// [contentType]: Optional. The MIME type of the file (e.g., 'image/jpeg', 'application/pdf').
  ///                This can be important for how the file is served or displayed.
  ///
  /// Returns the download URL of the uploaded file.
  /// Throws a [StorageServiceException] if an error occurs.
  Future<String> uploadFile({
    required dynamic fileData,
    required String path,
    String? contentType,
    // Map<String, String>? metadata, // Optional: For custom metadata
  });

  /// Deletes a file from cloud storage using its full download URL.
  ///
  /// [fileUrl]: The full HTTPS download URL of the file to be deleted.
  ///            Firebase Storage allows deletion by URL by parsing the path from it.
  ///
  /// Throws a [StorageServiceException] if an error occurs.
  Future<void> deleteFileByUrl(String fileUrl);

  /// Deletes a file from cloud storage using its storage path.
  ///
  /// [path]: The full path in cloud storage (e.g., 'user_avatars/userId.jpg').
  ///
  /// Throws a [StorageServiceException] if an error occurs.
  Future<void> deleteFileByPath(String path);


  // Optional: If direct URL retrieval by path is needed frequently and not part of upload response.
  // Future<String> getDownloadUrl(String path);
}

/// Custom exception for errors occurring in the StorageService.
class StorageServiceException implements Exception {
  final String message;
  final String? code; // Optional: specific error code (e.g., from Firebase Storage)
  final dynamic underlyingException;

  StorageServiceException(this.message, {this.code, this.underlyingException});

  @override
  String toString() {
    String result = 'StorageServiceException: $message';
    if (code != null) {
      result += ' (Code: $code)';
    }
    if (underlyingException != null) {
      result += '\nUnderlying exception: $underlyingException';
    }
    return result;
  }
}
