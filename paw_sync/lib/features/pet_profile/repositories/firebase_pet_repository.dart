// lib/features/pet_profile/repositories/firebase_pet_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paw_sync/core/utils/constants.dart'; // Import constants
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/features/pet_profile/repositories/pet_repository.dart';

class FirebasePetRepository implements PetRepository {
  final FirebaseFirestore _firestore;

  FirebasePetRepository(this._firestore);

  CollectionReference<Pet> get _petsCollection =>
      _firestore.collection(kPetsCollection).withConverter<Pet>(
            fromFirestore: (snapshot, _) => Pet.fromJson(snapshot.data()!),
            toFirestore: (pet, _) => pet.toJson(),
          );

  @override
  Future<void> addPet(Pet pet) async {
    try {
      if (pet.id.isEmpty) {
         final docRef = await _petsCollection.add(pet);
         print('Pet added with Firestore-generated ID: ${docRef.id}');
      } else {
        await _petsCollection.doc(pet.id).set(pet);
      }
    } on FirebaseException catch (e) {
      throw PetRepositoryException('Failed to add pet: ${e.message}', code: e.code, underlyingException: e);
    } catch (e) {
      throw PetRepositoryException('An unexpected error occurred while adding pet.', underlyingException: e);
    }
  }

  @override
  Future<void> deletePet(String petId) async {
    try {
      await _petsCollection.doc(petId).delete();
    } on FirebaseException catch (e) {
      throw PetRepositoryException('Failed to delete pet: ${e.message}', code: e.code, underlyingException: e);
    } catch (e) {
      throw PetRepositoryException('An unexpected error occurred while deleting pet.', underlyingException: e);
    }
  }

  @override
  Future<Pet?> getPetById(String petId) async {
    try {
      final docSnapshot = await _petsCollection.doc(petId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } on FirebaseException catch (e) {
      throw PetRepositoryException('Failed to get pet by ID: ${e.message}', code: e.code, underlyingException: e);
    } catch (e) {
      throw PetRepositoryException('An unexpected error occurred while fetching pet by ID.', underlyingException: e);
    }
  }

  @override
  Future<List<Pet>> getPets(String ownerId) async {
    try {
      final querySnapshot = await _petsCollection
          .where('ownerId', isEqualTo: ownerId)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw PetRepositoryException('Failed to get pets for owner: ${e.message}', code: e.code, underlyingException: e);
    } catch (e) {
      throw PetRepositoryException('An unexpected error occurred while fetching pets.', underlyingException: e);
    }
  }

  @override
  Stream<List<Pet>> getPetsStream(String ownerId) {
    try {
      return _petsCollection
          .where('ownerId', isEqualTo: ownerId)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
          .handleError((error) {
            if (error is FirebaseException) {
              throw PetRepositoryException('Error streaming pets: ${error.message}', code: error.code, underlyingException: error);
            }
            throw PetRepositoryException('An unexpected error occurred while streaming pets.', underlyingException: error);
          });
    } catch (e) {
      throw PetRepositoryException('Failed to set up pets stream.', underlyingException: e);
    }
  }

  @override
  Future<void> updatePet(Pet pet) async {
    try {
      await _petsCollection.doc(pet.id).update(pet.toJson());
    } on FirebaseException catch (e) {
      throw PetRepositoryException('Failed to update pet: ${e.message}', code: e.code, underlyingException: e);
    } catch (e) {
      throw PetRepositoryException('An unexpected error occurred while updating pet.', underlyingException: e);
    }
  }
}