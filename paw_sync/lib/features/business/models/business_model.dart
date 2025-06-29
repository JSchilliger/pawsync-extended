// lib/features/business/models/business_model.dart

import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // For GeoPoint if used

// Enum for different types of businesses
enum BusinessType { vet, groomer, sitter, store, park, other }

// Helper to convert BusinessType to string and back for Firestore
String businessTypeToString(BusinessType type) => type.toString().split('.').last;
BusinessType businessTypeFromString(String typeString) {
  return BusinessType.values.firstWhere(
    (e) => e.toString().split('.').last == typeString,
    orElse: () => BusinessType.other,
  );
}

@immutable
class BusinessModel {
  final String id; // Unique identifier for the business
  final String name;
  final BusinessType type;
  final String? description;
  final String? address; // Simple string address for now
  // final GeoPoint? location; // For map integration, requires cloud_firestore
  final String? phoneNumber;
  final String? email;
  final String? website;
  final List<String>? photoUrls; // URLs to business photos
  final String? ownerUserId; // Optional: if a user can claim/manage this business
  final OperatingHours? operatingHours; // Optional: structured operating hours

  // TODO: Consider fields for averageRating, numberOfReviews if denormalizing

  const BusinessModel({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.address,
    // this.location,
    this.phoneNumber,
    this.email,
    this.website,
    this.photoUrls,
    this.ownerUserId,
    this.operatingHours,
  });

  BusinessModel copyWith({
    String? id,
    String? name,
    BusinessType? type,
    String? description,
    String? address,
    // GeoPoint? location,
    String? phoneNumber,
    String? email,
    String? website,
    List<String>? photoUrls,
    String? ownerUserId,
    OperatingHours? operatingHours,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      address: address ?? this.address,
      // location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      photoUrls: photoUrls ?? this.photoUrls,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      operatingHours: operatingHours ?? this.operatingHours,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': businessTypeToString(type), // Store enum as string
      'description': description,
      'address': address,
      // 'location': location, // GeoPoint serializes automatically
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'photoUrls': photoUrls,
      'ownerUserId': ownerUserId,
      'operatingHours': operatingHours?.toJson(),
    };
  }

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: businessTypeFromString(json['type'] as String), // Convert string to enum
      description: json['description'] as String?,
      address: json['address'] as String?,
      // location: json['location'] as GeoPoint?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      photoUrls: (json['photoUrls'] as List<dynamic>?)?.map((url) => url as String).toList(),
      ownerUserId: json['ownerUserId'] as String?,
      operatingHours: json['operatingHours'] == null
          ? null
          : OperatingHours.fromJson(json['operatingHours'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return 'BusinessModel(id: $id, name: $name, type: $type, description: $description, address: $address, phoneNumber: $phoneNumber, email: $email, website: $website, photoUrls: $photoUrls, ownerUserId: $ownerUserId, operatingHours: $operatingHours)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BusinessModel &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.description == description &&
        other.address == address &&
        // other.location == location && // GeoPoint equality
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.website == website &&
        listEquals(other.photoUrls, photoUrls) &&
        other.ownerUserId == ownerUserId &&
        other.operatingHours == operatingHours;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        description.hashCode ^
        address.hashCode ^
        // location.hashCode ^
        phoneNumber.hashCode ^
        email.hashCode ^
        website.hashCode ^
        photoUrls.hashCode ^
        ownerUserId.hashCode ^
        operatingHours.hashCode;
  }
}

/// Represents operating hours for a business.
/// Could be a list of these if hours vary significantly (e.g. by season),
/// or a more complex structure for daily hours.
/// For simplicity, a general weekly structure.
@immutable
class OperatingHours {
  final String? monday; // e.g., "9:00 AM - 5:00 PM" or "Closed"
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final String? sunday;
  final String? notes; // e.g., "Closed on public holidays"

  const OperatingHours({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.notes,
  });

  OperatingHours copyWith({
    String? monday,
    String? tuesday,
    String? wednesday,
    String? thursday,
    String? friday,
    String? saturday,
    String? sunday,
    String? notes,
  }) {
    return OperatingHours(
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'notes': notes,
    };
  }

  factory OperatingHours.fromJson(Map<String, dynamic> json) {
    return OperatingHours(
      monday: json['monday'] as String?,
      tuesday: json['tuesday'] as String?,
      wednesday: json['wednesday'] as String?,
      thursday: json['thursday'] as String?,
      friday: json['friday'] as String?,
      saturday: json['saturday'] as String?,
      sunday: json['sunday'] as String?,
      notes: json['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OperatingHours &&
      other.monday == monday &&
      other.tuesday == tuesday &&
      other.wednesday == wednesday &&
      other.thursday == thursday &&
      other.friday == friday &&
      other.saturday == saturday &&
      other.sunday == sunday &&
      other.notes == notes;
  }

  @override
  int get hashCode {
    return monday.hashCode ^
      tuesday.hashCode ^
      wednesday.hashCode ^
      thursday.hashCode ^
      friday.hashCode ^
      saturday.hashCode ^
      sunday.hashCode ^
      notes.hashCode;
  }

   @override
  String toString() {
    return 'OperatingHours(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday, notes: $notes)';
  }
}
