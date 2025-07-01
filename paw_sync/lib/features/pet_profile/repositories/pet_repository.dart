// lib/features/pet_profile/repositories/pet_repository.dart

import 'package:paw_sync/features/pet_profile/models/pet_model.dart';

/// Abstract interface for a repository that manages pet data.
///
/// This defines the contract for data operations related to pets,
/// allowing for different implementations (e.g., Firebase, local database, mock).
abstract class PetRepository {
  /// Fetches a list of pets for a given owner.
  ///
  /// Throws a [PetRepositoryException] if an error occurs.
  Future<List<Pet>> getPets(String ownerId);

  /// Fetches a single pet by its ID.
  ///
  /// Returns null if the pet is not found.
  /// Throws a [PetRepositoryException] if an error occurs.
  Future<Pet?> getPetById(String petId);

  /// Adds a new pet to the repository.
  ///
  /// The [pet] object should have its `id` field populated by the repository
  /// if it's generated on the backend, or it should be pre-filled if client-generated.
  /// Throws a [PetRepositoryException] if an error occurs.
  Future<void> addPet(Pet pet);

  /// Updates an existing pet in the repository.
  ///
  /// Throws a [PetRepositoryException] if an error occurs or if the pet doesn't exist.
  Future<void> updatePet(Pet pet);

  /// Deletes a pet from the repository by its ID.
  ///
  /// Throws a [PetRepositoryException] if an error occurs.
  Future<void> deletePet(String petId);

  /// Provides a stream of pets for a given owner.
  ///
  /// This can be used for real-time updates from the backend.
  /// Throws a [PetRepositoryException] if an error occurs during stream setup.
  Stream<List<Pet>> getPetsStream(String ownerId);
}

/// Custom exception for errors occurring in the PetRepository.
class PetRepositoryException implements Exception {
  final String message;
  final String? code; // Ajout du code d'erreur optionnel
  final dynamic underlyingException; // Optional: To store the original exception

  PetRepositoryException(this.message, {this.code, this.underlyingException}); // Constructeur mis à jour

  @override
  String toString() {
    String result = 'PetRepositoryException: $message';
    if (code != null) {
      result += ' (Code: $code)';
    }
    if (underlyingException != null) {
      result += '\nUnderlying exception: $underlyingException';
    }
    return result;
  }
}