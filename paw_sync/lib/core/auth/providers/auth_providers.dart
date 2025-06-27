// lib/core/auth/providers/auth_providers.dart
// This file contains Riverpod providers related to Firebase Authentication.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to expose the FirebaseAuth instance.
// This allows other providers or widgets to access FirebaseAuth.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// StreamProvider to listen to Firebase authentication state changes.
// It emits the current Firebase User object (User?) whenever the auth state changes.
// This is useful for reacting to login/logout events throughout the app.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  // Watch the firebaseAuthProvider to get the FirebaseAuth instance.
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  // Return the stream of authentication state changes.
  return firebaseAuth.authStateChanges();
});

// TODO: Implement an AsyncNotifier or StateNotifier for authentication actions.
// This notifier will handle methods like:
// - signInWithEmailAndPassword
// - createUserWithEmailAndPassword
// - signInWithGoogle
// - signOut
// It will also manage loading and error states for these operations.

/*
// Example structure for an AuthNotifier (AsyncNotifier):
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // Initialize with the current user state or null
    // This could also listen to authStateChangesProvider initially
    return ref.watch(firebaseAuthProvider).currentUser;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading(); // Set loading state
    try {
      final userCredential = await ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      state = AsyncData(userCredential.user); // Set data state on success
    } on FirebaseAuthException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace); // Set error state on failure
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace); // Handle other errors
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(firebaseAuthProvider).signOut();
      state = const AsyncData(null); // User is null after sign out
    } on FirebaseAuthException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
  // Add other methods like signUp, signInWithGoogle etc.
}
*/

// A simple provider to check if a user is currently logged in.
// This is derived from the authStateChangesProvider.
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.asData?.value != null;
});
