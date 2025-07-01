// lib/features/pet_profile/screens/add_pet_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:paw_sync/core/auth/providers/auth_providers.dart'; // For currentUserIdProvider indirectly via pet_providers
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/features/pet_profile/providers/pet_providers.dart';
import 'package:paw_sync/core/widgets/themed_buttons.dart';

class SavePetScreen extends ConsumerStatefulWidget {
  final String? petIdForEdit; // Changed from existingPet
  final Pet?
      initialPetData; // Optional: if we already have the data from previous screen

  const SavePetScreen({super.key, this.petIdForEdit, this.initialPetData});

  @override
  ConsumerState<SavePetScreen> createState() => _SavePetScreenState();
}

class _SavePetScreenState extends ConsumerState<SavePetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _photoUrlController;
  DateTime? _selectedBirthDate;

  Pet? _loadedPetForEdit; // To store the fetched pet data in edit mode
  bool _isScreenLoading = false; // For loading pet data in edit mode
  bool _isSaving = false; // For save/update operation

  bool get _isEditMode => widget.petIdForEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _speciesController = TextEditingController();
    _breedController = TextEditingController();
    _photoUrlController = TextEditingController();

    if (_isEditMode) {
      if (widget.initialPetData != null) {
        // If initial data is passed (e.g. from PetDetailScreen), use it directly
        _populateForm(widget.initialPetData!);
        _loadedPetForEdit = widget.initialPetData;
      } else {
        // Fetch pet data if only ID is provided
        _fetchPetDetails();
      }
    }
  }

  Future<void> _fetchPetDetails() async {
    if (widget.petIdForEdit == null) return;
    setState(() {
      _isScreenLoading = true;
    });
    try {
      final petData = await ref.read(petByIdProvider(widget.petIdForEdit!).future);
      if (petData != null && mounted) {
        _populateForm(petData);
        _loadedPetForEdit = petData;
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Could not load pet details for editing. ID: ${widget.petIdForEdit}')),
        );
        // Optionally pop or disable form
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching pet details: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScreenLoading = false;
        });
      }
    }
  }

  void _populateForm(Pet pet) {
    _nameController.text = pet.name;
    _speciesController.text = pet.species;
    _breedController.text = pet.breed ?? '';
    _photoUrlController.text = pet.photoUrl ?? '';
    _selectedBirthDate = pet.birthDate;
    // Update text controller for birth date if it's separate
    // This is handled by the TextFormField's controller logic later
    setState(() {}); // Ensure UI rebuilds with populated date if needed
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1980), // Arbitrary past date
      lastDate: DateTime.now(),   // Pet cannot be born in the future
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isEditMode && _loadedPetForEdit == null) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Pet details not loaded for editing.')),
        );
        return;
      }
      setState(() {
        _isSaving = true;
      });

      final currentUserId = ref.read(currentUserIdProvider);
      if (currentUserId == null && !_isEditMode) { // User ID is essential for new pets
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in. Cannot add pet.')),
        );
        setState(() { _isSaving = false; });
        return;
      }

      if (_isEditMode) {
        // Update existing pet
        final updatedPet = _loadedPetForEdit!.copyWith( // Use _loadedPetForEdit
          name: _nameController.text.trim(),
          species: _speciesController.text.trim(),
          breed: _breedController.text.trim().isNotEmpty ? _breedController.text.trim() : null,
          birthDate: _selectedBirthDate,
          photoUrl: _photoUrlController.text.trim().isNotEmpty ? _photoUrlController.text.trim() : null,
          // Ensure other complex fields like vaccinationRecords, medicalHistory are preserved
          // or handled if they are editable on this screen (currently they are not).
          // copyWith should preserve them if not provided.
        );

        try {
          final updatePetAction = ref.read(updatePetProvider);
          await updatePetAction(updatedPet);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${updatedPet.name} updated successfully!')),
          );
          if (mounted) {
            // Potentially pop twice if coming from Detail -> Edit
            // Or use GoRouter to navigate back to the detail screen specifically.
            // For now, a single pop might go back to PetDetailScreen or PetProfileScreen
            // depending on how navigation to edit was set up.
            Navigator.of(context).pop();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating pet: ${e.toString()}')),
          );
        }

      } else {
        // Add new pet
        // Let Firestore generate the ID by passing an empty string or ensuring Pet model handles it.
        // The existing FirebasePetRepository handles empty ID by letting Firestore generate it.
        final newPet = Pet(
          id: '', // Firestore will generate this
          ownerId: currentUserId,
          name: _nameController.text.trim(),
          species: _speciesController.text.trim(),
          breed: _breedController.text.trim().isNotEmpty ? _breedController.text.trim() : null,
          birthDate: _selectedBirthDate,
          photoUrl: _photoUrlController.text.trim().isNotEmpty ? _photoUrlController.text.trim() : null,
          vaccinationRecords: [], // Initialize as empty for new pet
          medicalHistory: [], // Initialize as empty for new pet
          groomingPreferences: widget.existingPet?.groomingPreferences, // Preserve if somehow editing a new pet form template
          behaviorProfile: widget.existingPet?.behaviorProfile, // Preserve
        );

        try {
          final addPetAction = ref.read(addPetProvider);
          await addPetAction(newPet);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newPet.name} added successfully!')),
          );
          if (mounted) {
            Navigator.of(context).pop(); // Go back to pet profile screen
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding pet: ${e.toString()}')),
          );
        }
      }

    } catch (e) { // This outer catch is likely redundant if inner try-catches handle specifics
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Pet' : 'Add New Pet'),
      ),
      body: _isScreenLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Pet Details', style: textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
                    const SizedBox(height: 24),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the pet\'s name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Species Field
                    TextFormField(
                      controller: _speciesController,
                      decoration: const InputDecoration(labelText: 'Species (e.g., Dog, Cat)'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the pet\'s species.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Breed Field
                    TextFormField(
                      controller: _breedController,
                      decoration: const InputDecoration(labelText: 'Breed (Optional)'),
                      // No validator, as it's optional
                    ),
                    const SizedBox(height: 16),

                    // Birth Date Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Birth Date (Optional)',
                        hintText: 'Select Date',
                        suffixIcon: Icon(Icons.calendar_today, color: colorScheme.primary),
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _selectedBirthDate == null
                            ? ''
                            : DateFormat.yMMMd().format(_selectedBirthDate!), // e.g., Jan 23, 2023
                      ),
                      onTap: () => _selectBirthDate(context),
                    ),
                    const SizedBox(height: 16),

                    // Photo URL Field
                    TextFormField(
                      controller: _photoUrlController,
                      decoration: const InputDecoration(labelText: 'Photo URL (Optional)'),
                      keyboardType: TextInputType.url,
                      // No validator, as it's optional. Basic URL validation could be added later.
                    ),
                    const SizedBox(height: 32),

                    PrimaryActionButton(
                      text: _isEditMode ? 'Update Pet' : 'Save Pet',
                      isLoading: _isSaving, // Use _isSaving
                      onPressed: _isSaving ? null : _submitForm, // Use _isSaving
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
