// lib/features/pet_profile/screens/pet_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/features/pet_profile/providers/pet_providers.dart';

class PetDetailScreen extends ConsumerWidget {
  final String petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsyncValue = ref.watch(petByIdProvider(petId));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(petAsyncValue.value?.name ?? 'Pet Details'), // Show pet name if loaded
        actions: [
          petAsyncValue.when(
            data: (pet) => pet == null ? const SizedBox.shrink() : IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Pet',
              onPressed: () {
                // Navigate to SavePetScreen in edit mode
                GoRouter.of(context).pushNamed(
                  AppRoutes.editPet,
                  pathParameters: {'petId': petId},
                  extra: pet, // Pass the loaded pet data as extra
                );
              },
            ),
            loading: () => const SizedBox.shrink(), // Or a disabled button
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: petAsyncValue.when(
        data: (pet) {
          if (pet == null) {
            return const Center(child: Text('Pet not found.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Pet Photo (if available)
                if (pet.photoUrl != null && pet.photoUrl!.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        pet.photoUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                if (pet.photoUrl != null && pet.photoUrl!.isNotEmpty)
                  const SizedBox(height: 24),

                // Pet Name
                Center(
                  child: Text(
                    pet.name,
                    style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(),

                // Basic Info Section
                _buildSectionTitle(context, 'Basic Information'),
                _buildDetailRow(context, 'Species:', pet.species),
                _buildDetailRow(context, 'Breed:', pet.breed ?? 'N/A'),
                _buildDetailRow(context, 'Birth Date:', pet.birthDate != null ? DateFormat.yMMMd().format(pet.birthDate!) : 'N/A'),
                const SizedBox(height: 16),
                Divider(),

                // Vaccination Records Section
                _buildSectionTitle(context, 'Vaccination Records'),
                if (pet.vaccinationRecords == null || pet.vaccinationRecords!.isEmpty)
                  const Text('No vaccination records available.')
                else
                  ...pet.vaccinationRecords!.map((record) => _buildVaccinationCard(context, record)).toList(),
                const SizedBox(height: 16),
                Divider(),

                // Medical History Section
                _buildSectionTitle(context, 'Medical History'),
                if (pet.medicalHistory == null || pet.medicalHistory!.isEmpty)
                  const Text('No medical history available.')
                else
                  ...pet.medicalHistory!.map((event) => _buildMedicalEventCard(context, event)).toList(),
                const SizedBox(height: 16),
                Divider(),

                // Grooming Preferences Section (if available)
                if (pet.groomingPreferences != null) ...[
                  _buildSectionTitle(context, 'Grooming Preferences'),
                  _buildDetailRow(context, 'Preferred Groomer:', pet.groomingPreferences!.preferredGroomer ?? 'N/A'),
                  _buildDetailRow(context, 'Cut Style:', pet.groomingPreferences!.cutStyle ?? 'N/A'),
                  _buildDetailRow(context, 'Frequency:', pet.groomingPreferences!.frequencyInWeeks != null ? '${pet.groomingPreferences!.frequencyInWeeks} weeks' : 'N/A'),
                  if (pet.groomingPreferences!.notes != null && pet.groomingPreferences!.notes!.isNotEmpty)
                    _buildNotesList(context, 'Notes:', pet.groomingPreferences!.notes!),
                  const SizedBox(height: 16),
                  Divider(),
                ],

                // Behavior Profile Section (if available)
                if (pet.behaviorProfile != null) ...[
                  _buildSectionTitle(context, 'Behavior Profile'),
                  _buildDetailRow(context, 'Temperament:', pet.behaviorProfile!.temperament ?? 'N/A'),
                  _buildDetailRow(context, 'Interaction with other pets:', pet.behaviorProfile!.interactionWithOtherPets ?? 'N/A'),
                  _buildDetailRow(context, 'Interaction with children:', pet.behaviorProfile!.interactionWithChildren ?? 'N/A'),
                  if (pet.behaviorProfile!.triggers != null && pet.behaviorProfile!.triggers!.isNotEmpty)
                     _buildNotesList(context, 'Triggers:', pet.behaviorProfile!.triggers!),
                  if (pet.behaviorProfile!.trainingNotes != null && pet.behaviorProfile!.trainingNotes!.isNotEmpty)
                     _buildNotesList(context, 'Training Notes:', pet.behaviorProfile!.trainingNotes!),
                  if (pet.behaviorProfile!.generalNotes != null && pet.behaviorProfile!.generalNotes!.isNotEmpty)
                     _buildNotesList(context, 'General Notes:', pet.behaviorProfile!.generalNotes!),
                  const SizedBox(height: 16),
                ],
                // Add more sections as needed (e.g., Reminders linked to this pet)
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading pet details: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(BuildContext context, String label, List<String> notes) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...notes.map((note) => Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 2.0),
            child: Row(
              children: [
                const Text("• ", style: TextStyle(fontSize: 14)),
                Expanded(child: Text(note, style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildVaccinationCard(BuildContext context, VaccinationRecord record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.vaccineName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Administered: ${DateFormat.yMMMd().format(record.dateAdministered)}'),
            if (record.nextDueDate != null)
              Text('Next Due: ${DateFormat.yMMMd().format(record.nextDueDate!)}'),
            if (record.veterinarian != null && record.veterinarian!.isNotEmpty)
              Text('Veterinarian: ${record.veterinarian}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalEventCard(BuildContext context, MedicalEvent event) {
     return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${event.type} - ${DateFormat.yMMMd().format(event.date)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(event.description),
            if (event.veterinarianOrClinic != null && event.veterinarianOrClinic!.isNotEmpty)
              Text('Clinic/Vet: ${event.veterinarianOrClinic}'),
            // TODO: Display attachments if any
          ],
        ),
      ),
    );
  }
}
