// lib/features/pet_profile/screens/pet_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/features/pet_profile/providers/pet_providers.dart';
import 'package:paw_sync/features/pet_profile/widgets/save_vaccination_record_form.dart';
import 'package:paw_sync/features/pet_profile/widgets/save_medical_event_form.dart'; // Import the medical event form

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
            data: (pet) {
              if (pet == null) return const SizedBox.shrink();
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Pet',
                    onPressed: () {
                      GoRouter.of(context).pushNamed(
                        AppRoutes.editPet,
                        pathParameters: {'petId': petId},
                        extra: pet,
                      );
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'delete') {
                        // Show confirmation dialog
                        final bool? confirmed = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: Text('Are you sure you want to delete ${pet.name}? This action cannot be undone.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.of(dialogContext).pop(false),
                                ),
                                TextButton(
                                  child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                                  onPressed: () => Navigator.of(dialogContext).pop(true),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed == true) {
                          try {
                            await ref.read(deletePetProvider)(petId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${pet.name} deleted successfully.')),
                            );
                            // Navigate back to pet list screen
                            if (context.mounted) GoRouter.of(context).go(AppRoutes.home);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error deleting pet: ${e.toString()}')),
                            );
                          }
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Delete Pet'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(context, 'Vaccination Records'),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
                      tooltip: 'Add Vaccination Record',
                      onPressed: () {
                        _showSaveVaccinationRecordSheet(context, ref, pet);
                      },
                    ),
                  ],
                ),
                if (pet.vaccinationRecords == null || pet.vaccinationRecords!.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Text('No vaccination records available.'),
                  )
                else
                  ...pet.vaccinationRecords!.map((record) => _buildVaccinationCard(context, ref, pet, record)).toList(),
                const SizedBox(height: 16),
                Divider(),

                // Medical History Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(context, 'Medical History'),
                    IconButton(
                      icon: Icon(Icons.event_note_outlined, color: colorScheme.primary), // Different icon for variety
                      tooltip: 'Add Medical Event',
                      onPressed: () {
                        _showSaveMedicalEventSheet(context, ref, pet);
                      },
                    ),
                  ],
                ),
                if (pet.medicalHistory == null || pet.medicalHistory!.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Text('No medical history available.'),
                  )
                else
                  ...pet.medicalHistory!.map((event) => _buildMedicalEventCard(context, ref, pet, event)).toList(),
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

  Widget _buildVaccinationCard(BuildContext context, WidgetRef ref, Pet pet, VaccinationRecord record) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(record.vaccineName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: 20, color: colorScheme.onSurfaceVariant),
                      tooltip: 'Edit Vaccination',
                      onPressed: () {
                        _showSaveVaccinationRecordSheet(context, ref, pet, existingRecord: record);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20, color: colorScheme.error),
                      tooltip: 'Delete Vaccination',
                      onPressed: () {
                        _confirmDeleteVaccinationRecord(context, ref, pet, record);
                      },
                    ),
                  ],
                )
              ],
            ),
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

  Widget _buildMedicalEventCard(BuildContext context, WidgetRef ref, Pet pet, MedicalEvent event) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${event.type} - ${DateFormat.yMMMd().format(event.date)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: 20, color: colorScheme.onSurfaceVariant),
                      tooltip: 'Edit Medical Event',
                      onPressed: () {
                        _showSaveMedicalEventSheet(context, ref, pet, existingEvent: event);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20, color: colorScheme.error),
                      tooltip: 'Delete Medical Event',
                      onPressed: () {
                        _confirmDeleteMedicalEvent(context, ref, pet, event);
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(event.description),
            if (event.veterinarianOrClinic != null && event.veterinarianOrClinic!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('Clinic/Vet: ${event.veterinarianOrClinic}', style: Theme.of(context).textTheme.bodySmall),
              ),
            // TODO: Display attachments if any (e.g., event.attachmentUrls)
          ],
        ),
      ),
    );
  }

  void _showSaveVaccinationRecordSheet(
    BuildContext context,
    WidgetRef ref,
    Pet pet,
    {VaccinationRecord? existingRecord}
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for keyboard visibility
      builder: (BuildContext bottomSheetContext) {
        return SaveVaccinationRecordForm(
          pet: pet,
          existingRecord: existingRecord,
          onSave: (VaccinationRecord savedRecord) async {
            List<VaccinationRecord> updatedRecords = List.from(pet.vaccinationRecords ?? []);

            if (existingRecord != null) { // Edit mode
              // Find the index of the old record and replace it
              // This relies on VaccinationRecord implementing == correctly or using a unique ID if records had one.
              // For now, assuming direct object comparison or simple list management.
              // A more robust way would be to assign unique IDs to each record.
              final index = updatedRecords.indexWhere((r) =>
                r.vaccineName == existingRecord.vaccineName &&
                r.dateAdministered == existingRecord.dateAdministered
                // Add more fields for robust matching if needed, or use a unique ID
              );
              if (index != -1) {
                updatedRecords[index] = savedRecord;
              } else {
                // Fallback or error: old record not found, treat as new? Or show error?
                // For simplicity, let's add if not found, though this shouldn't happen in pure edit.
                updatedRecords.add(savedRecord);
              }
            } else { // Add mode
              updatedRecords.add(savedRecord);
            }

            // Sort records by date administered (descending) for consistent display
            updatedRecords.sort((a, b) => b.dateAdministered.compareTo(a.dateAdministered));

            final updatedPet = pet.copyWith(vaccinationRecords: updatedRecords);

            try {
              final updatePetAction = ref.read(updatePetProvider);
              await updatePetAction(updatedPet);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Vaccination record ${existingRecord != null ? "updated" : "added"} successfully!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving vaccination record: ${e.toString()}')),
              );
            }
            // The PetDetailScreen will rebuild automatically due to petByIdProvider watching changes.
          },
        );
      },
    );
  }

  void _confirmDeleteVaccinationRecord(
    BuildContext context,
    WidgetRef ref,
    Pet pet,
    VaccinationRecord recordToDelete,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the vaccination record for "${recordToDelete.vaccineName}" administered on ${DateFormat.yMMMd().format(recordToDelete.dateAdministered)}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      List<VaccinationRecord> updatedRecords = List.from(pet.vaccinationRecords ?? []);
      // Remove based on object equality. Assumes VaccinationRecord implements == correctly.
      // If not, might need to match based on unique properties or add a unique ID to VaccinationRecord.
      updatedRecords.removeWhere((r) =>
        r.vaccineName == recordToDelete.vaccineName &&
        r.dateAdministered == recordToDelete.dateAdministered &&
        r.nextDueDate == recordToDelete.nextDueDate &&
        r.veterinarian == recordToDelete.veterinarian
      );

      final updatedPet = pet.copyWith(vaccinationRecords: updatedRecords);

      try {
        final updatePetAction = ref.read(updatePetProvider);
        await updatePetAction(updatedPet);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vaccination record deleted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting vaccination record: ${e.toString()}')),
        );
      }
      // PetDetailScreen will rebuild due to petByIdProvider update.
    }
  }

  void _showSaveMedicalEventSheet(
    BuildContext context,
    WidgetRef ref,
    Pet pet,
    {MedicalEvent? existingEvent}
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bottomSheetContext) {
        return SaveMedicalEventForm(
          pet: pet,
          existingEvent: existingEvent,
          onSave: (MedicalEvent savedEvent) async {
            List<MedicalEvent> updatedEvents = List.from(pet.medicalHistory ?? []);

            if (existingEvent != null) { // Edit mode
              final index = updatedEvents.indexWhere((e) => e.id == existingEvent.id);
              if (index != -1) {
                updatedEvents[index] = savedEvent;
              } else {
                // Should not happen if editing an existing event, but as a fallback:
                updatedEvents.add(savedEvent);
              }
            } else { // Add mode
              updatedEvents.add(savedEvent);
            }

            // Sort events by date (descending) for consistent display
            updatedEvents.sort((a, b) => b.date.compareTo(a.date));

            final updatedPet = pet.copyWith(medicalHistory: updatedEvents);

            try {
              final updatePetAction = ref.read(updatePetProvider);
              await updatePetAction(updatedPet);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Medical event ${existingEvent != null ? "updated" : "added"} successfully!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving medical event: ${e.toString()}')),
              );
            }
            // PetDetailScreen will rebuild automatically.
          },
        );
      },
    );
  }

  void _confirmDeleteMedicalEvent(
    BuildContext context,
    WidgetRef ref,
    Pet pet,
    MedicalEvent eventToDelete,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the medical event: "${eventToDelete.type} on ${DateFormat.yMMMd().format(eventToDelete.date)}?"'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      List<MedicalEvent> updatedEvents = List.from(pet.medicalHistory ?? []);
      updatedEvents.removeWhere((event) => event.id == eventToDelete.id); // Remove by ID

      final updatedPet = pet.copyWith(medicalHistory: updatedEvents);

      try {
        final updatePetAction = ref.read(updatePetProvider);
        await updatePetAction(updatedPet);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medical event deleted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting medical event: ${e.toString()}')),
        );
      }
      // PetDetailScreen will rebuild due to petByIdProvider update.
    }
  }
}
