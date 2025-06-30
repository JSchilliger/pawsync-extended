// lib/core/auth/notifiers/auth_notifier.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart';
import 'package:paw_sync/core/auth/repositories/auth_repository.dart';

/// Manages authentication state and provides methods for auth operations.
///
/// The state of this notifier is [AsyncValue<fb_auth.User?>], representing the
/// current Firebase user. It automatically updates based on `authStateChangesProvider`.
/// Methods for sign-in, sign-up, and sign-out interact with the [AuthRepository]
/// and primarily manage loading/error states, relying on `authStateChangesProvider`
/// to reflect the successful authentication state.
class AuthNotifier extends AsyncNotifier<fb_auth.User?> {
  @override
  Future<fb_auth.User?> build() async {
    // Watch the authStateChangesProvider. This will keep the notifier's state
    // in sync with Firebase's auth state.
    // When a user signs in or out, authStateChangesProvider will emit a new value,
    // and this notifier's state will automatically update to AsyncData(user) or AsyncData(null).
    final authState = ref.watch(authStateChangesProvider);
    return authState.asData?.value; // Return the user object from AsyncData, or null
  }

  /// Signs in a user with the given email and password.
  ///
  /// Sets loading state and updates to error state on failure.
  /// Success state is handled by the `build` method reacting to `authStateChangesProvider`.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email: email,
            password: password,
          );
      // On success, authStateChangesProvider will emit the new user,
      // and the build method will update the state to AsyncData(user).
      // If state doesn't update immediately as expected (e.g. due to stream delays),
      // one might manually set state = AsyncData(newUser) here, but it's often cleaner
      // to rely on the single source of truth from authStateChanges.
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  /// Signs up a new user with the given email, password, and optional display name.
  ///
  /// Sets loading state and updates to error state on failure.
  /// Success state is handled by the `build` method reacting to `authStateChangesProvider`.
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password, {
    String? displayName,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
            email: email,
            password: password,
            displayName: displayName,
          );
      // As with signIn, authStateChangesProvider should reflect the new user.
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  /// Initiates Google Sign-In.
  ///
  /// Sets loading state and updates to error state on failure or if unimplemented.
  /// Success state is handled by the `build` method.
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      // authStateChangesProvider should reflect the new user on successful Google Sign-In.
    } catch (e, s) {
      // This will catch the UnimplementedError from the repository for now.
      state = AsyncError(e, s);
    }
  }

  /// Signs out the current user.
  ///
  /// Sets loading state and updates to error state on failure.
  /// On success, `authStateChangesProvider` will emit null, updating the state.
  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      // authStateChangesProvider will emit null, updating the state to AsyncData(null).
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
