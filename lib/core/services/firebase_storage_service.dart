// lib/core/services/firebase_storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:paw_sync/core/services/storage_service.dart';

class FirebaseStorageService implements StorageService {
  final firebase_storage.FirebaseStorage _firebaseStorage;

  FirebaseStorageService(this._firebaseStorage);

  /// Constructs the storage path for a pet's profile image.
  String _petProfileImagePath(String userId, String petId, String fileName) {
    // Using a consistent file name like 'profile.jpg' can simplify overwrite/update logic.
    // If fileName includes extension, use as is. Otherwise, append a default like .jpg or .png.
    // For simplicity, assume fileName includes the desired extension or is just a base name.
    // A common practice is to use a fixed name for profile pictures, e.g., 'profile_photo.jpg'
    return 'users/$userId/pets/$petId/$fileName';
  }

  @override
  Future<String> uploadPetProfileImage({
    required File imageFile,
    required String userId,
    required String petId,
    required String fileName,
  }) async {
    try {
      final path = _petProfileImagePath(userId, petId, fileName);
      final ref = _firebaseStorage.ref().child(path);

      // Determine content type or let Firebase SDK try to determine
      // For example, if fileName is 'profile.jpg', metadata could be 'image/jpeg'
      // String contentType = 'image/jpeg'; // Default or determine from file extension
      // if (fileName.endsWith('.png')) {
      //   contentType = 'image/png';
      // }
      // final metadata = firebase_storage.SettableMetadata(contentType: contentType);
      // await ref.putFile(imageFile, metadata);

      // Simpler: let putFile try to infer, or set no specific metadata unless issues arise
      await ref.putFile(imageFile);

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on firebase_storage.FirebaseException catch (e) {
      // Handle Firebase specific errors (e.g., permission denied, object not found)
      print('FirebaseStorageException during upload: ${e.code} - ${e.message}');
      throw StorageServiceException('Failed to upload pet image: ${e.message}', underlyingException: e);
    } catch (e) {
      // Handle other errors
      print('Unexpected error during upload: $e');
      throw StorageServiceException('An unexpected error occurred while uploading pet image.', underlyingException: e);
    }
  }

  @override
  Future<void> deletePetProfileImage({
    required String userId,
    required String petId,
    required String fileName,
  }) async {
    try {
      final path = _petProfileImagePath(userId, petId, fileName);
      final ref = _firebaseStorage.ref().child(path);
      await ref.delete();
    } on firebase_storage.FirebaseException catch (e) {
      // It's common to ignore "object-not-found" errors during delete if you want deletion to be idempotent.
      if (e.code == 'object-not-found') {
        print('Image to delete not found (path: $userId/$petId/$fileName). Assuming already deleted or never existed.');
        return; // Successfully "deleted" as it's not there.
      }
      print('FirebaseStorageException during delete: ${e.code} - ${e.message}');
      throw StorageServiceException('Failed to delete pet image: ${e.message}', underlyingException: e);
    } catch (e) {
      print('Unexpected error during delete: $e');
      throw StorageServiceException('An unexpected error occurred while deleting pet image.', underlyingException: e);
    }
  }
}
