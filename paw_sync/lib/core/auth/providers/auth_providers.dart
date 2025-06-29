// lib/core/auth/providers/auth_providers.dart
// This file contains Riverpod providers related to user authentication.

import 'package:firebase_auth/firebase_auth.dart' as fb_auth; // Aliased for clarity
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/core/auth/models/user_model.dart';
import 'package:paw_sync/core/auth/repositories/auth_repository.dart';
import 'package:paw_sync/core/auth/repositories/firebase_auth_repository.dart'; // Import concrete implementation
import 'package:paw_sync/core/auth/notifiers/auth_notifier.dart'; // Import the AuthNotifier

// Provider to expose the FirebaseAuth instance.
// This allows other providers or widgets to access FirebaseAuth if needed directly,
// though interaction should primarily be through the AuthRepository.
final firebaseAuthProvider = Provider<fb_auth.FirebaseAuth>((ref) {
  return fb_auth.FirebaseAuth.instance;
});

// Provider for the AuthRepository implementation.
// Now returns an instance of FirebaseAuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuthInstance = ref.watch(firebaseAuthProvider);
  // If GoogleSignIn was fully implemented, it would be passed here too:
  // final googleSignInInstance = ref.watch(googleSignInProvider); // Assuming a googleSignInProvider
  // return FirebaseAuthRepository(firebaseAuthInstance, googleSignInInstance);
  return FirebaseAuthRepository(firebaseAuthInstance);
});

// Provider for the stream of authentication state changes from the repository.
// Using fb_auth.User? to match the type from FirebaseAuth.
// UI widgets can listen to this provider to react to login/logout events.
final authStateChangesProvider = StreamProvider<fb_auth.User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Provider to get the current Firebase User object from the repository.
final currentUserProvider = Provider<fb_auth.User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
});

// Provider to get the current custom UserModel.
// This maps the Firebase User to our custom UserModel.
final currentUserModelProvider = Provider<UserModel?>((ref) {
  final firebaseUser = ref.watch(currentUserProvider);
  if (firebaseUser != null) {
    // This mapping could be more sophisticated, potentially done within UserModel or a dedicated mapper.
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      // isEmailVerified: firebaseUser.emailVerified, // Example if added to UserModel
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
    // Note: This will currently throw UnimplementedError from FirebaseAuthRepository
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

// Provider for the AuthNotifier.
// This is the primary provider UI should interact with for auth operations and state.
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, fb_auth.User?>(AuthNotifier.new);

/*
// The commented out AuthNotifier class structure below is now implemented in
// lib/core/auth/notifiers/auth_notifier.dart
// Keeping it here for historical reference during this dev session is fine,
// but it would typically be removed once the actual class is in its own file.

class AuthNotifier extends AsyncNotifier<fb_auth.User?> {
  @override
  Future<fb_auth.User?> build() async {
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
