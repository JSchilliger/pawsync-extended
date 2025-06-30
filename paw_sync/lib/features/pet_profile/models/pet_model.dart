// lib/features/pet_profile/models/pet_model.dart

import 'package:flutter/foundation.dart';
import 'package:paw_sync/core/utils/enums.dart'; // For PetSpecies, if/when species field is refactored

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
  // final List<String>? medicalHistoryNotes; // Replaced by medicalHistory
  final List<MedicalEvent>? medicalHistory;
  final GroomingPreferences? groomingPreferences;
  final BehaviorProfile? behaviorProfile;


  const Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    this.breed,
    this.birthDate,
    this.photoUrl,
    this.vaccinationRecords,
    // this.medicalHistoryNotes,
    this.medicalHistory,
    this.groomingPreferences,
    this.behaviorProfile,
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
    // List<String>? medicalHistoryNotes, // Replaced
    List<MedicalEvent>? medicalHistory,
    GroomingPreferences? groomingPreferences,
    BehaviorProfile? behaviorProfile,
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
      // medicalHistoryNotes: medicalHistoryNotes ?? this.medicalHistoryNotes, // Replaced
      medicalHistory: medicalHistory ?? this.medicalHistory,
      groomingPreferences: groomingPreferences ?? this.groomingPreferences,
      behaviorProfile: behaviorProfile ?? this.behaviorProfile,
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
      // 'medicalHistoryNotes': medicalHistoryNotes, // Replaced
      'medicalHistory': medicalHistory?.map((e) => e.toJson()).toList(),
      'groomingPreferences': groomingPreferences?.toJson(),
      'behaviorProfile': behaviorProfile?.toJson(),
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
      // medicalHistoryNotes: (json['medicalHistoryNotes'] as List<dynamic>?) // Replaced
      //     ?.map((note) => note as String)
      //     .toList(),
      medicalHistory: (json['medicalHistory'] as List<dynamic>?)
          ?.map((e) => MedicalEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      groomingPreferences: json['groomingPreferences'] == null
          ? null
          : GroomingPreferences.fromJson(json['groomingPreferences'] as Map<String, dynamic>),
      behaviorProfile: json['behaviorProfile'] == null
          ? null
          : BehaviorProfile.fromJson(json['behaviorProfile'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return 'Pet(id: $id, ownerId: $ownerId, name: $name, species: $species, breed: $breed, birthDate: $birthDate, photoUrl: $photoUrl, vaccinationRecords: $vaccinationRecords, medicalHistory: $medicalHistory, groomingPreferences: $groomingPreferences, behaviorProfile: $behaviorProfile)';
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
        listEquals(other.medicalHistory, medicalHistory) &&
        other.groomingPreferences == groomingPreferences &&
        other.behaviorProfile == behaviorProfile;
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
        medicalHistory.hashCode ^
        groomingPreferences.hashCode ^
        behaviorProfile.hashCode;
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

/// Represents a structured medical event for a pet.
/// This replaces the simple `medicalHistoryNotes` list for more detailed tracking.
@immutable
class MedicalEvent {
  final String id; // Unique ID for the event (e.g., UUID)
  final DateTime date;
  final String type; // e.g., 'Vet Visit', 'Allergy Diagnosis', 'Procedure', 'Observation', 'Medication'
  final String description;
  final String? veterinarianOrClinic; // Name or clinic, or potentially a businessId
  final List<String>? attachmentUrls; // URLs to documents/images in cloud storage

  const MedicalEvent({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    this.veterinarianOrClinic,
    this.attachmentUrls,
  });

  MedicalEvent copyWith({
    String? id,
    DateTime? date,
    String? type,
    String? description,
    String? veterinarianOrClinic,
    List<String>? attachmentUrls,
  }) {
    return MedicalEvent(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      veterinarianOrClinic: veterinarianOrClinic ?? this.veterinarianOrClinic,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'description': description,
      'veterinarianOrClinic': veterinarianOrClinic,
      'attachmentUrls': attachmentUrls,
    };
  }

  factory MedicalEvent.fromJson(Map<String, dynamic> json) {
    return MedicalEvent(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      description: json['description'] as String,
      veterinarianOrClinic: json['veterinarianOrClinic'] as String?,
      attachmentUrls: (json['attachmentUrls'] as List<dynamic>?)
          ?.map((url) => url as String)
          .toList(),
    );
  }

  @override
  String toString() {
    return 'MedicalEvent(id: $id, date: $date, type: $type, description: $description, veterinarianOrClinic: $veterinarianOrClinic, attachmentUrls: $attachmentUrls)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalEvent &&
        other.id == id &&
        other.date == date &&
        other.type == type &&
        other.description == description &&
        other.veterinarianOrClinic == veterinarianOrClinic &&
        listEquals(other.attachmentUrls, attachmentUrls);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        type.hashCode ^
        description.hashCode ^
        veterinarianOrClinic.hashCode ^
        attachmentUrls.hashCode;
  }
}

/// Represents grooming preferences for a pet.
@immutable
class GroomingPreferences {
  final String? preferredGroomer; // Could be a name or a businessId
  final String? cutStyle;
  final int? frequencyInWeeks;
  final List<String>? notes; // e.g., 'sensitive skin', 'likes blueberry facial'

  const GroomingPreferences({
    this.preferredGroomer,
    this.cutStyle,
    this.frequencyInWeeks,
    this.notes,
  });

  GroomingPreferences copyWith({
    String? preferredGroomer,
    String? cutStyle,
    int? frequencyInWeeks,
    List<String>? notes,
  }) {
    return GroomingPreferences(
      preferredGroomer: preferredGroomer ?? this.preferredGroomer,
      cutStyle: cutStyle ?? this.cutStyle,
      frequencyInWeeks: frequencyInWeeks ?? this.frequencyInWeeks,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredGroomer': preferredGroomer,
      'cutStyle': cutStyle,
      'frequencyInWeeks': frequencyInWeeks,
      'notes': notes,
    };
  }

  factory GroomingPreferences.fromJson(Map<String, dynamic> json) {
    return GroomingPreferences(
      preferredGroomer: json['preferredGroomer'] as String?,
      cutStyle: json['cutStyle'] as String?,
      frequencyInWeeks: json['frequencyInWeeks'] as int?,
      notes: (json['notes'] as List<dynamic>?)?.map((note) => note as String).toList(),
    );
  }

  @override
  String toString() {
    return 'GroomingPreferences(preferredGroomer: $preferredGroomer, cutStyle: $cutStyle, frequencyInWeeks: $frequencyInWeeks, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroomingPreferences &&
        other.preferredGroomer == preferredGroomer &&
        other.cutStyle == cutStyle &&
        other.frequencyInWeeks == frequencyInWeeks &&
        listEquals(other.notes, notes);
  }

  @override
  int get hashCode {
    return preferredGroomer.hashCode ^
        cutStyle.hashCode ^
        frequencyInWeeks.hashCode ^
        notes.hashCode;
  }
}

/// Represents the behavior profile of a pet.
@immutable
class BehaviorProfile {
  final String? temperament; // e.g., 'Calm', 'Anxious', 'Playful', 'Aggressive with strangers'
  final List<String>? triggers; // e.g., 'Loud noises', 'Strangers at the door', 'Other dogs on leash'
  final List<String>? trainingNotes; // e.g., 'Responds well to treats', 'Knows sit, stay, come'
  final String? interactionWithOtherPets; // e.g., 'Good', 'Cautious', 'Aggressive', 'Not tested'
  final String? interactionWithChildren; // e.g., 'Good', 'Tolerant', 'Avoids', 'Not recommended'
  final List<String>? generalNotes; // Other general behavior notes

  const BehaviorProfile({
    this.temperament,
    this.triggers,
    this.trainingNotes,
    this.interactionWithOtherPets,
    this.interactionWithChildren,
    this.generalNotes,
  });

  BehaviorProfile copyWith({
    String? temperament,
    List<String>? triggers,
    List<String>? trainingNotes,
    String? interactionWithOtherPets,
    String? interactionWithChildren,
    List<String>? generalNotes,
  }) {
    return BehaviorProfile(
      temperament: temperament ?? this.temperament,
      triggers: triggers ?? this.triggers,
      trainingNotes: trainingNotes ?? this.trainingNotes,
      interactionWithOtherPets: interactionWithOtherPets ?? this.interactionWithOtherPets,
      interactionWithChildren: interactionWithChildren ?? this.interactionWithChildren,
      generalNotes: generalNotes ?? this.generalNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperament': temperament,
      'triggers': triggers,
      'trainingNotes': trainingNotes,
      'interactionWithOtherPets': interactionWithOtherPets,
      'interactionWithChildren': interactionWithChildren,
      'generalNotes': generalNotes,
    };
  }

  factory BehaviorProfile.fromJson(Map<String, dynamic> json) {
    return BehaviorProfile(
      temperament: json['temperament'] as String?,
      triggers: (json['triggers'] as List<dynamic>?)?.map((item) => item as String).toList(),
      trainingNotes: (json['trainingNotes'] as List<dynamic>?)?.map((item) => item as String).toList(),
      interactionWithOtherPets: json['interactionWithOtherPets'] as String?,
      interactionWithChildren: json['interactionWithChildren'] as String?,
      generalNotes: (json['generalNotes'] as List<dynamic>?)?.map((item) => item as String).toList(),
    );
  }

  @override
  String toString() {
    return 'BehaviorProfile(temperament: $temperament, triggers: $triggers, trainingNotes: $trainingNotes, interactionWithOtherPets: $interactionWithOtherPets, interactionWithChildren: $interactionWithChildren, generalNotes: $generalNotes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BehaviorProfile &&
        other.temperament == temperament &&
        listEquals(other.triggers, triggers) &&
        listEquals(other.trainingNotes, trainingNotes) &&
        other.interactionWithOtherPets == interactionWithOtherPets &&
        other.interactionWithChildren == interactionWithChildren &&
        listEquals(other.generalNotes, generalNotes);
  }

  @override
  int get hashCode {
    return temperament.hashCode ^
        triggers.hashCode ^
        trainingNotes.hashCode ^
        interactionWithOtherPets.hashCode ^
        interactionWithChildren.hashCode ^
        generalNotes.hashCode;
  }
}
