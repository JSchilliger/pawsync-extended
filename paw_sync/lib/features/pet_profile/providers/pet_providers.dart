// lib/features/pet_profile/providers/pet_providers.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // For FirebaseFirestore
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/features/pet_profile/repositories/pet_repository.dart';
import 'package:paw_sync/features/pet_profile/repositories/firebase_pet_repository.dart'; // Import concrete implementation
// It's good practice to also import the auth providers if currentUserIdProvider depends on them.
// For now, currentUserIdProvider is a placeholder, but in a real app:
// import 'package:paw_sync/core/auth/providers/auth_providers.dart';


// Provider to expose the FirebaseFirestore instance.
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Provider for the PetRepository implementation.
// Now returns an instance of FirebasePetRepository.
final petRepositoryProvider = Provider<PetRepository>((ref) {
  final firestoreInstance = ref.watch(firebaseFirestoreProvider);
  return FirebasePetRepository(firestoreInstance);
});

// Provider to fetch a list of pets for a given owner.
// This is an asynchronous provider that will typically make a network request.
// We use .family to pass the ownerId.
final petsProvider = FutureProvider.autoDispose.family<List<Pet>, String>((ref, ownerId) {
  final petRepository = ref.watch(petRepositoryProvider);
  return petRepository.getPets(ownerId);
});

// Provider to fetch a stream of pets for a given owner.
// Useful for real-time updates.
final petsStreamProvider = StreamProvider.autoDispose.family<List<Pet>, String>((ref, ownerId) {
  final petRepository = ref.watch(petRepositoryProvider);
  return petRepository.getPetsStream(ownerId);
});

// Provider to fetch a single pet by its ID.
final petByIdProvider = FutureProvider.autoDispose.family<Pet?, String>((ref, petId) {
  final petRepository = ref.watch(petRepositoryProvider);
  return petRepository.getPetById(petId);
});


// It's often better to manage state mutations (add, update, delete) through
// StateNotifierProviders or AsyncNotifierProviders that encapsulate business logic
// and expose methods to perform these actions.
// For simplicity at this stage, we keep simple providers that directly call repository methods.
// In a full app, dedicated Notifiers are preferred for managing state and side effects.

// Provider for adding a pet.
final addPetProvider = Provider((ref) {
  final petRepository = ref.watch(petRepositoryProvider);
  return (Pet pet) async {
    // Potentially add more logic here: validation, analytics, etc.
    await petRepository.addPet(pet);
    // After adding, invalidate providers that show lists of pets to trigger a refresh.
    final currentOwnerId = ref.read(currentUserIdProvider);
    if (currentOwnerId != null) {
      ref.invalidate(petsProvider(currentOwnerId));
      ref.invalidate(petsStreamProvider(currentOwnerId)); // Though streams might auto-update, invalidation ensures freshness if needed
    }
    // If there's a global pets list provider not dependent on ID, invalidate that too.
    // ref.invalidate(allPetsProvider); // Example
  };
});

// Provider for updating a pet.
final updatePetProvider = Provider((ref) {
  final petRepository = ref.watch(petRepositoryProvider);
  return (Pet pet) async {
    await petRepository.updatePet(pet);
    // Invalidate relevant providers to reflect the update
    final currentOwnerId = ref.read(currentUserIdProvider);
    if (currentOwnerId != null) {
      ref.invalidate(petsProvider(currentOwnerId));
      ref.invalidate(petsStreamProvider(currentOwnerId));
    }
    ref.invalidate(petByIdProvider(pet.id)); // Invalidate the specific pet entry
  };
});

// Provider for deleting a pet.
final deletePetProvider = Provider((ref) {
  final petRepository = ref.watch(petRepositoryProvider);
  return (String petId) async {
    // Store ownerId before deletion if needed for invalidating owner-specific lists
    final petToDelete = await ref.read(petByIdProvider(petId).future);
    final ownerId = petToDelete?.ownerId ?? ref.read(currentUserIdProvider);

    await petRepository.deletePet(petId);
    // Invalidate relevant providers
    if (ownerId != null) {
      ref.invalidate(petsProvider(ownerId));
      ref.invalidate(petsStreamProvider(ownerId));
    }
    ref.invalidate(petByIdProvider(petId)); // This pet no longer exists
  };
});

/// Placeholder for the current user's ID.
/// In a real app, this would come from an authentication provider like `currentUserModelProvider.uid`.
final currentUserIdProvider = Provider<String?>((ref) {
  // Example of how it might be connected in a real app:
  // final userModel = ref.watch(currentUserModelProvider); // Assuming currentUserModelProvider is defined in auth_providers
  // return userModel?.uid;
  print("Warning: currentUserIdProvider is returning a placeholder null value for PetProfile.");
  return null; // Placeholder - MUST BE REPLACED LATER
});

/// Provider for the current user's pets list.
/// This demonstrates using the currentUserIdProvider with the family provider.
final currentUserPetsProvider = FutureProvider.autoDispose<List<Pet>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    // If no user is logged in, return an empty list.
    // The UI should ideally not call this if no user is logged in,
    // or handle the empty/error state gracefully.
    return Future.value([]);
  }
  return ref.watch(petsProvider(userId).future);
});

/// Stream provider for the current user's pets list.
final currentUserPetsStreamProvider = StreamProvider.autoDispose<List<Pet>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value([]);
  }
  return ref.watch(petsStreamProvider(userId).stream);
});
