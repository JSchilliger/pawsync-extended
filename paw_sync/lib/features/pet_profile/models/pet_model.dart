// lib/features/pet_profile/models/pet_model.dart

import 'package:flutter/foundation.dart';

/// Represents a pet in the Paw Sync application.
///
/// This model includes essential details about a pet, along with methods
/// for data manipulation like copying and serialization/deserialization.
@immutable
class Pet {
  final String id; // Unique identifier for the pet
  final String ownerId; // Identifier for the pet's owner
  final String name;
  final String species; // e.g., Dog, Cat, Bird
  final String? breed;
  final DateTime? birthDate;
  final String? photoUrl; // URL to the pet's photo in cloud storage
  final List<VaccinationRecord>? vaccinationRecords;
  final List<String>? medicalHistoryNotes; // Simple list of notes for now

  const Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    this.breed,
    this.birthDate,
    this.photoUrl,
    this.vaccinationRecords,
    this.medicalHistoryNotes,
  });

  /// Creates a copy of this Pet but with the given fields replaced with the new values.
  Pet copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? species,
    String? breed,
    DateTime? birthDate,
    String? photoUrl,
    List<VaccinationRecord>? vaccinationRecords,
    List<String>? medicalHistoryNotes,
  }) {
    return Pet(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      birthDate: birthDate ?? this.birthDate,
      photoUrl: photoUrl ?? this.photoUrl,
      vaccinationRecords: vaccinationRecords ?? this.vaccinationRecords,
      medicalHistoryNotes: medicalHistoryNotes ?? this.medicalHistoryNotes,
    );
  }

  /// Converts this Pet instance to a JSON map.
  /// Dates are stored in ISO 8601 string format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'species': species,
      'breed': breed,
      'birthDate': birthDate?.toIso8601String(),
      'photoUrl': photoUrl,
      'vaccinationRecords': vaccinationRecords?.map((v) => v.toJson()).toList(),
      'medicalHistoryNotes': medicalHistoryNotes,
    };
  }

  /// Creates a Pet instance from a JSON map.
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      photoUrl: json['photoUrl'] as String?,
      vaccinationRecords: (json['vaccinationRecords'] as List<dynamic>?)
          ?.map((v) => VaccinationRecord.fromJson(v as Map<String, dynamic>))
          .toList(),
      medicalHistoryNotes: (json['medicalHistoryNotes'] as List<dynamic>?)
          ?.map((note) => note as String)
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Pet(id: $id, ownerId: $ownerId, name: $name, species: $species, breed: $breed, birthDate: $birthDate, photoUrl: $photoUrl, vaccinationRecords: $vaccinationRecords, medicalHistoryNotes: $medicalHistoryNotes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pet &&
        other.id == id &&
        other.ownerId == ownerId &&
        other.name == name &&
        other.species == species &&
        other.breed == breed &&
        other.birthDate == birthDate &&
        other.photoUrl == photoUrl &&
        listEquals(other.vaccinationRecords, vaccinationRecords) &&
        listEquals(other.medicalHistoryNotes, medicalHistoryNotes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        name.hashCode ^
        species.hashCode ^
        breed.hashCode ^
        birthDate.hashCode ^
        photoUrl.hashCode ^
        vaccinationRecords.hashCode ^
        medicalHistoryNotes.hashCode;
  }
}

/// Represents a single vaccination record for a pet.
@immutable
class VaccinationRecord {
  final String vaccineName;
  final DateTime dateAdministered;
  final DateTime? nextDueDate;
  final String? veterinarian; // Name or clinic

  const VaccinationRecord({
    required this.vaccineName,
    required this.dateAdministered,
    this.nextDueDate,
    this.veterinarian,
  });

  VaccinationRecord copyWith({
    String? vaccineName,
    DateTime? dateAdministered,
    DateTime? nextDueDate,
    String? veterinarian,
  }) {
    return VaccinationRecord(
      vaccineName: vaccineName ?? this.vaccineName,
      dateAdministered: dateAdministered ?? this.dateAdministered,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      veterinarian: veterinarian ?? this.veterinarian,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vaccineName': vaccineName,
      'dateAdministered': dateAdministered.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'veterinarian': veterinarian,
    };
  }

  factory VaccinationRecord.fromJson(Map<String, dynamic> json) {
    return VaccinationRecord(
      vaccineName: json['vaccineName'] as String,
      dateAdministered: DateTime.parse(json['dateAdministered'] as String),
      nextDueDate: json['nextDueDate'] == null
          ? null
          : DateTime.parse(json['nextDueDate'] as String),
      veterinarian: json['veterinarian'] as String?,
    );
  }

  @override
  String toString() {
    return 'VaccinationRecord(vaccineName: $vaccineName, dateAdministered: $dateAdministered, nextDueDate: $nextDueDate, veterinarian: $veterinarian)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VaccinationRecord &&
        other.vaccineName == vaccineName &&
        other.dateAdministered == dateAdministered &&
        other.nextDueDate == nextDueDate &&
        other.veterinarian == veterinarian;
  }

  @override
  int get hashCode {
    return vaccineName.hashCode ^
        dateAdministered.hashCode ^
        nextDueDate.hashCode ^
        veterinarian.hashCode;
  }
}
