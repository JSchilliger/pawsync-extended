// lib/core/auth/models/user_model.dart

import 'package:flutter/foundation.dart';

/// Represents an authenticated user in the Paw Sync application.
///
/// This model typically stores information retrieved from Firebase Authentication
/// and potentially additional profile data from Firestore.
@immutable
class UserModel {
  final String uid; // Unique ID from Firebase Auth
  final String? email;
  final String? displayName;
  final String? photoUrl;
  // You can add other custom fields here, e.g.,
  // final DateTime? lastLogin;
  // final bool? isEmailVerified;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    // this.lastLogin,
    // this.isEmailVerified,
  });

  /// Creates a copy of this UserModel but with the given fields replaced with the new values.
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    // DateTime? lastLogin,
    // bool? isEmailVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      // lastLogin: lastLogin ?? this.lastLogin,
      // isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  /// Converts this UserModel instance to a JSON map.
  /// Useful if storing user profile data in Firestore.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      // 'lastLogin': lastLogin?.toIso8601String(),
      // 'isEmailVerified': isEmailVerified,
    };
  }

  /// Creates a UserModel instance from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      // lastLogin: json['lastLogin'] == null
      //     ? null
      //     : DateTime.parse(json['lastLogin'] as String),
      // isEmailVerified: json['isEmailVerified'] as bool?,
    );
  }

  /// Creates a UserModel from a Firebase User object.
  /// This is a common factory constructor when working with Firebase Auth.
  /// Note: This would require importing 'package:firebase_auth/firebase_auth.dart'.
  /// For now, this is commented out as we are only defining models.
  /*
  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      // isEmailVerified: firebaseUser.emailVerified,
    );
  }
  */

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoUrl == photoUrl;
        // other.lastLogin == lastLogin &&
        // other.isEmailVerified == isEmailVerified;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        displayName.hashCode ^
        photoUrl.hashCode;
        // lastLogin.hashCode ^
        // isEmailVerified.hashCode;
  }
}
