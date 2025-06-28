// lib/core/auth/providers/auth_providers.dart
// This file contains Riverpod providers related to user authentication.

import 'package:firebase_auth/firebase_auth.dart' show User; // Only for User type
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/core/auth/models/user_model.dart';
import 'package:paw_sync/core/auth/repositories/auth_repository.dart';

// Provider for the AuthRepository implementation.
// Concrete implementation (e.g., FirebaseAuthRepository) will be provided here.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // In a real application, you would return an instance of a concrete implementation:
  // return FirebaseAuthRepository(FirebaseAuth.instance);
  // Or for testing:
  // return MockAuthRepository();
  throw UnimplementedError(
      'AuthRepository implementation not provided yet. This is an API-only definition.');
});

// Provider for the stream of authentication state changes from the repository.
// UI widgets can listen to this provider to react to login/logout events.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Provider to get the current Firebase User object from the repository.
final currentUserProvider = Provider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
});

// Provider to get the current custom UserModel.
// This maps the Firebase User to our custom UserModel.
final currentUserModelProvider = Provider<UserModel?>((ref) {
  final firebaseUser = ref.watch(currentUserProvider);
  if (firebaseUser != null) {
    // This mapping could be more sophisticated or happen in the repository.
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }
  return null;
});


// TODO: Implement an AsyncNotifier or StateNotifier for authentication actions
// for more robust state management (loading, error handling).
// The providers below are simplified for API definition.
// This notifier will handle methods like:
// --- Mutation Providers (simplified for API definition) ---

// Provider for signing in with email and password.
final emailPasswordSignInProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ({required String email, required String password}) async {
    return await authRepository.signInWithEmailAndPassword(
        email: email, password: password);
  };
});

// Provider for creating a user with email and password.
final emailPasswordSignUpProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return (
      {required String email,
      required String password,
      String? displayName}) async {
    return await authRepository.createUserWithEmailAndPassword(
        email: email, password: password, displayName: displayName);
  };
});

// Provider for signing in with Google.
final googleSignInProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return () async {
    return await authRepository.signInWithGoogle();
  };
});

// Provider for signing out.
final signOutProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return () async {
    await authRepository.signOut();
  };
});

// Provider for sending a password reset email.
final sendPasswordResetEmailProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ({required String email}) async {
    await authRepository.sendPasswordResetEmail(email: email);
  };
});


// A simple provider to check if a user is currently logged in.
// This is derived from the currentUserProvider for synchronous check.
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/*
// Example structure for an AuthNotifier (AsyncNotifier):
// This is a good pattern for handling async operations with loading/error states.
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // Initialize with the current user state by watching authStateChangesProvider
    final authState = ref.watch(authStateChangesProvider);
    return authState.asData?.value;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);
    try {
      final user = await authRepository.signInWithEmailAndPassword(email: email, password: password);
      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, {String? displayName}) async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);
    try {
      final user = await authRepository.createUserWithEmailAndPassword(email: email, password: password, displayName: displayName);
      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);
    try {
      final user = await authRepository.signInWithGoogle();
      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.signOut();
      state = const AsyncData(null); // User is null after sign out
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    // This action doesn't change the auth state directly,
    // so it might not need to set loading/error on the main state.
    // Or it could be a separate notifier/provider if its state needs to be tracked.
    final authRepository = ref.read(authRepositoryProvider);
    // Consider how to provide feedback for this operation in the UI.
    await authRepository.sendPasswordResetEmail(email: email);
  }
}
*/
