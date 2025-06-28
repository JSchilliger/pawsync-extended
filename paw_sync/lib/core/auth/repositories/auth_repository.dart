// lib/core/auth/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart' show User; // Only for User type, not implementation
import 'package:paw_sync/core/auth/models/user_model.dart'; // Your custom user model

/// Abstract interface for a repository that manages user authentication.
///
/// This defines the contract for authentication operations, allowing for
/// different implementations (e.g., Firebase Auth, mock).
abstract class AuthRepository {
  /// Stream of authentication state changes.
  /// Emits a [User] from `firebase_auth` when the user logs in or out,
  /// or null if logged out. This can be mapped to `UserModel`.
  Stream<User?> get authStateChanges;

  /// Gets the current Firebase [User].
  /// Returns null if no user is currently signed in.
  User? get currentUser;

  /// Signs in a user with email and password.
  ///
  /// Throws an [AuthRepositoryException] if an error occurs.
  /// Returns a [User] object from Firebase upon success.
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user account with email and password.
  ///
  /// Throws an [AuthRepositoryException] if an error occurs.
  /// Returns a [User] object from Firebase upon success.
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName, // Optional: set display name during creation
  });

  /// Signs in a user with Google.
  ///
  /// Throws an [AuthRepositoryException] if an error occurs.
  /// Returns a [User] object from Firebase upon success.
  Future<User?> signInWithGoogle();

  /// Signs out the current user.
  ///
  /// Throws an [AuthRepositoryException] if an error occurs.
  Future<void> signOut();

  /// Sends a password reset email to the given email address.
  ///
  /// Throws an [AuthRepositoryException] if an error occurs.
  Future<void> sendPasswordResetEmail({required String email});

  // Optional: Method to map Firebase User to your custom UserModel
  // This could also live in the UserModel class or a mapper utility.
  // Future<UserModel?> userModelFromFirebaseUser(User? firebaseUser);
}

/// Custom exception for errors occurring in the AuthRepository.
class AuthRepositoryException implements Exception {
  final String message;
  final String? code; // Optional: specific error code (e.g., from Firebase)
  final dynamic underlyingException; // Optional: To store the original exception

  AuthRepositoryException(this.message, {this.code, this.underlyingException});

  @override
  String toString() {
    String result = 'AuthRepositoryException: $message';
    if (code != null) {
      result += ' (Code: $code)';
    }
    if (underlyingException != null) {
      result += '\nUnderlying exception: $underlyingException';
    }
    return result;
  }
}
