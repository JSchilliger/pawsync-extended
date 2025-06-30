// lib/core/auth/repositories/firebase_auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart'; // Import GoogleSignIn
import 'package:paw_sync/core/auth/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final fb_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn; // Add GoogleSignIn instance

  FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn); // Update constructor

  @override
  Stream<fb_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  fb_auth.User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<fb_auth.User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthRepositoryException(e.message ?? 'An unknown error occurred.', code: e.code, underlyingException: e);
    } catch (e) {
      throw AuthRepositoryException('An unexpected error occurred during sign-in.', underlyingException: e);
    }
  }

  @override
  Future<fb_auth.User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null && displayName != null) {
        await userCredential.user!.updateDisplayName(displayName);
        // To reflect display name immediately, you might need to reload the user
        // or the authStateChanges stream will eventually pick it up.
        // For simplicity, we're not explicitly reloading here.
      }
      return userCredential.user;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthRepositoryException(e.message ?? 'An unknown error occurred.', code: e.code, underlyingException: e);
    } catch (e) {
      throw AuthRepositoryException('An unexpected error occurred during sign-up.', underlyingException: e);
    }
  }

  @override
  Future<fb_auth.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in process
        print('Google Sign-In cancelled by user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final fb_auth.AuthCredential credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on fb_auth.FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions related to credential sign-in
      print('FirebaseAuthException during Google Sign-In: ${e.code} - ${e.message}');
      throw AuthRepositoryException(e.message ?? 'Google Sign-In with Firebase failed.', code: e.code, underlyingException: e);
    } catch (e, stackTrace) {
      // Handle other errors, including potential issues with _googleSignIn.signIn() itself
      // (e.g., network errors, platform specific issues if not configured correctly)
      print('Unexpected error during Google Sign-In: $e\n$stackTrace');
      throw AuthRepositoryException('An unexpected error occurred during Google Sign-In.', underlyingException: e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // It's good practice to sign out from both Firebase and GoogleSignIn
      await _googleSignIn.signOut(); // Sign out from Google
      await _firebaseAuth.signOut(); // Sign out from Firebase
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthRepositoryException(e.message ?? 'Firebase sign out failed.', code: e.code, underlyingException: e);
    } catch (e) {
      throw AuthRepositoryException('An unexpected error occurred during sign-out.', underlyingException: e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthRepositoryException(e.message ?? 'Failed to send password reset email.', code: e.code, underlyingException: e);
    } catch (e) {
      throw AuthRepositoryException('An unexpected error occurred while sending password reset email.', underlyingException: e);
    }
  }
}
