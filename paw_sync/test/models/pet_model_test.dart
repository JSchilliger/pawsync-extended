// test/models/pet_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';

void main() {
  group('Pet Model Tests', () {
    finalDateTime = DateTime(2023, 1, 15);
    final vaccinationRecordJson = {
      'vaccineName': 'Rabies',
      'dateAdministered': finalDateTime.toIso8601String(),
      'nextDueDate': finalDateTime.add(const Duration(days: 365)).toIso8601String(),
      'veterinarian': 'Dr. Smith',
    };
    final medicalEventJson = {
      'id': 'med123',
      'date': finalDateTime.toIso8601String(),
      'type': 'Checkup',
      'description': 'Annual checkup, all good.',
      'veterinarianOrClinic': 'City Vet Clinic',
      'attachmentUrls': ['http://example.com/report.pdf'],
    };
    final groomingPreferencesJson = {
      'preferredGroomer': 'Groomer A',
      'cutStyle': 'Lion Cut',
      'frequencyInWeeks': 4,
      'notes': ['Loves belly rubs'],
    };
    final behaviorProfileJson = {
      'temperament': 'Playful',
      'triggers': ['Loud noises'],
      'trainingNotes': ['Knows sit'],
      'interactionWithOtherPets': 'Good',
      'interactionWithChildren': 'Good',
      'generalNotes': ['Very energetic'],
    };

    final petJson = {
      'id': 'pet123',
      'ownerId': 'owner456',
      'name': 'Buddy',
      'species': 'Dog',
      'breed': 'Golden Retriever',
      'birthDate': finalDateTime.toIso8601String(),
      'photoUrl': 'http://example.com/buddy.jpg',
      'vaccinationRecords': [vaccinationRecordJson],
      'medicalHistory': [medicalEventJson],
      'groomingPreferences': groomingPreferencesJson,
      'behaviorProfile': behaviorProfileJson,
    };

    final petModel = Pet(
      id: 'pet123',
      ownerId: 'owner456',
      name: 'Buddy',
      species: 'Dog',
      breed: 'Golden Retriever',
      birthDate: finalDateTime,
      photoUrl: 'http://example.com/buddy.jpg',
      vaccinationRecords: [
        VaccinationRecord.fromJson(vaccinationRecordJson),
      ],
      medicalHistory: [
        MedicalEvent.fromJson(medicalEventJson),
      ],
      groomingPreferences: GroomingPreferences.fromJson(groomingPreferencesJson),
      behaviorProfile: BehaviorProfile.fromJson(behaviorProfileJson),
    );

    test('Pet.fromJson creates a valid Pet model', () {
      final pet = Pet.fromJson(petJson);
      expect(pet.id, 'pet123');
      expect(pet.name, 'Buddy');
      expect(pet.species, 'Dog');
      expect(pet.breed, 'Golden Retriever');
      expect(pet.birthDate, finalDateTime);
      expect(pet.photoUrl, 'http://example.com/buddy.jpg');
      expect(pet.vaccinationRecords, isNotNull);
      expect(pet.vaccinationRecords!.length, 1);
      expect(pet.vaccinationRecords![0].vaccineName, 'Rabies');
      expect(pet.medicalHistory, isNotNull);
      expect(pet.medicalHistory!.length, 1);
      expect(pet.medicalHistory![0].id, 'med123');
      expect(pet.groomingPreferences, isNotNull);
      expect(pet.groomingPreferences!.cutStyle, 'Lion Cut');
      expect(pet.behaviorProfile, isNotNull);
      expect(pet.behaviorProfile!.temperament, 'Playful');
    });

    test('Pet.toJson returns a valid JSON map', () {
      final json = petModel.toJson();
      expect(json['id'], 'pet123');
      expect(json['name'], 'Buddy');
      expect(json['species'], 'Dog');
      expect(json['breed'], 'Golden Retriever');
      expect(json['birthDate'], finalDateTime.toIso8601String());
      expect(json['photoUrl'], 'http://example.com/buddy.jpg');
      expect(json['vaccinationRecords'], isNotNull);
      expect(json['vaccinationRecords'] is List, isTrue);
      expect((json['vaccinationRecords'] as List).length, 1);
      expect((json['vaccinationRecords'] as List)[0]['vaccineName'], 'Rabies');
      expect(json['medicalHistory'], isNotNull);
      expect(json['medicalHistory'] is List, isTrue);
      expect((json['medicalHistory'] as List).length, 1);
      expect((json['medicalHistory'] as List)[0]['id'], 'med123');
      expect(json['groomingPreferences'], isNotNull);
      expect(json['groomingPreferences']['cutStyle'], 'Lion Cut');
      expect(json['behaviorProfile'], isNotNull);
      expect(json['behaviorProfile']['temperament'], 'Playful');
    });

    test('Pet.copyWith creates a copy with updated values', () {
      final updatedPet = petModel.copyWith(name: 'Charlie', breed: 'Labrador');
      expect(updatedPet.id, petModel.id);
      expect(updatedPet.name, 'Charlie');
      expect(updatedPet.breed, 'Labrador');
      expect(updatedPet.species, petModel.species);
      expect(updatedPet.birthDate, petModel.birthDate);
    });

    test('Pet.copyWith handles null values correctly', () {
      final petWithNulls = Pet(
        id: 'pet789',
        ownerId: 'owner101',
        name: 'Ghost',
        species: 'Direwolf',
        // breed, birthDate, photoUrl, etc. are null
      );
      final json = petWithNulls.toJson();
      expect(json['breed'], isNull);
      expect(json['birthDate'], isNull);
      expect(json['photoUrl'], isNull);
      expect(json['vaccinationRecords'], isNull); // or empty list depending on model constructor
      expect(json['medicalHistory'], isNull);
      expect(json['groomingPreferences'], isNull);
      expect(json['behaviorProfile'], isNull);

      final copiedPet = petWithNulls.copyWith(breed: "Arctic Wolf");
      expect(copiedPet.breed, "Arctic Wolf");
      expect(copiedPet.birthDate, isNull); // Ensure other nulls are preserved
    });

    // Tests for sub-models (VaccinationRecord, MedicalEvent, etc.)
    // These ensure their toJson/fromJson and copyWith work independently too.

    group('VaccinationRecord Tests', () {
      final record = VaccinationRecord.fromJson(vaccinationRecordJson);
      test('fromJson', () {
        expect(record.vaccineName, 'Rabies');
        expect(record.dateAdministered, finalDateTime);
      });
      test('toJson', () {
        expect(record.toJson(), vaccinationRecordJson);
      });
    });

    group('MedicalEvent Tests', () {
       final event = MedicalEvent.fromJson(medicalEventJson);
      test('fromJson', () {
        expect(event.id, 'med123');
        expect(event.type, 'Checkup');
      });
      test('toJson', () {
        expect(event.toJson(), medicalEventJson);
      });
    });

    group('GroomingPreferences Tests', () {
      final prefs = GroomingPreferences.fromJson(groomingPreferencesJson);
      test('fromJson', () {
        expect(prefs.preferredGroomer, 'Groomer A');
        expect(prefs.frequencyInWeeks, 4);
      });
      test('toJson', () {
        expect(prefs.toJson(), groomingPreferencesJson);
      });
    });

    group('BehaviorProfile Tests', () {
      final profile = BehaviorProfile.fromJson(behaviorProfileJson);
      test('fromJson', () {
        expect(profile.temperament, 'Playful');
        expect(profile.triggers, contains('Loud noises'));
      });
      test('toJson', () {
        expect(profile.toJson(), behaviorProfileJson);
      });
    });
  });
}
