// lib/features/pet_profile/screens/add_pet_screen.dart
import 'dart:io'; // For File type
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:intl/intl.dart'; // For date formatting
import 'package:paw_sync/core/auth/providers/auth_providers.dart';
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/features/pet_profile/providers/pet_providers.dart';
import 'package:paw_sync/core/widgets/themed_buttons.dart';
import 'package:paw_sync/core/services/service_providers.dart'; // Import StorageService provider
import 'package:uuid/uuid.dart'; // Import Uuid

class SavePetScreen extends ConsumerStatefulWidget {
  final String? petIdForEdit;
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
  // late TextEditingController _photoUrlController; // Removed, will use _pickedImageFile and _loadedPetForEdit.photoUrl
  DateTime? _selectedBirthDate;
  File? _pickedImageFile; // To store the picked image file

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
    // _photoUrlController = TextEditingController(); // Removed

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
    // _photoUrlController.text = pet.photoUrl ?? ''; // Removed
    _selectedBirthDate = pet.birthDate;
    // _pickedImageFile remains null initially, photo displayed from pet.photoUrl
    setState(() {}); // Ensure UI rebuilds with populated date if needed
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    // _photoUrlController.dispose(); // Removed
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80, // Compress image slightly
        maxWidth: 800,     // Resize image
      );
      if (pickedFile != null) {
        setState(() {
          _pickedImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle exceptions, e.g., permissions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
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

      String? finalPhotoUrl = _isEditMode ? _loadedPetForEdit?.photoUrl : null;
      String petIdToUse = _isEditMode ? _loadedPetForEdit!.id : const Uuid().v4();

      if (_pickedImageFile != null) {
        if (currentUserId == null) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User ID not found for image upload.')),
          );
          setState(() { _isSaving = false; });
          return;
        }
        try {
          final storageService = ref.read(storageServiceProvider);
          // Using a consistent file name for simplicity, e.g., profile_photo.jpg
          // Or generate a unique name if multiple photos per pet are expected later.
          const photoFileName = 'profile_photo.jpg';
          finalPhotoUrl = await storageService.uploadPetProfileImage(
            imageFile: _pickedImageFile!,
            userId: currentUserId, // currentUserId should be valid here if not editing
            petId: petIdToUse,
            fileName: photoFileName,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: ${e.toString()}')),
          );
          setState(() { _isSaving = false; });
          return; // Stop submission if image upload fails
        }
      }


      if (_isEditMode) {
        // Update existing pet
        final updatedPet = _loadedPetForEdit!.copyWith(
          name: _nameController.text.trim(),
          species: _speciesController.text.trim(),
          breed: _breedController.text.trim().isNotEmpty ? _breedController.text.trim() : null,
          birthDate: _selectedBirthDate,
          photoUrl: finalPhotoUrl, // Use the potentially updated photoUrl
        );

        try {
          final updatePetAction = ref.read(updatePetProvider);
          await updatePetAction(updatedPet);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${updatedPet.name} updated successfully!')),
          );
          if (mounted) {
            Navigator.of(context).pop();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating pet: ${e.toString()}')),
          );
        }

      } else {
        // Add new pet
        final newPet = Pet(
          id: petIdToUse, // Use client-generated ID
          ownerId: currentUserId!, // currentUserId is checked above for add mode if image picked
          name: _nameController.text.trim(),
          species: _speciesController.text.trim(),
          breed: _breedController.text.trim().isNotEmpty ? _breedController.text.trim() : null,
          birthDate: _selectedBirthDate,
          photoUrl: finalPhotoUrl, // Use the potentially uploaded photoUrl
          vaccinationRecords: [],
          medicalHistory: [],
          groomingPreferences: null,
          behaviorProfile: null,
        );

        try {
          final addPetAction = ref.read(addPetProvider);
          await addPetAction(newPet);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newPet.name} added successfully!')),
          );
          if (mounted) {
            Navigator.of(context).pop();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding pet: ${e.toString()}')),
          );
        }
      }
    } // main if (_formKey.currentState?.validate() ?? false)
    // No outer catch here, specific catches are inside.
    finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
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
                    // Image Picker Section
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(75),
                              border: Border.all(color: colorScheme.primary, width: 2),
                              image: _pickedImageFile != null
                                  ? DecorationImage(image: FileImage(_pickedImageFile!), fit: BoxFit.cover)
                                  : (_isEditMode && _loadedPetForEdit?.photoUrl != null && _loadedPetForEdit!.photoUrl!.isNotEmpty)
                                      ? DecorationImage(image: NetworkImage(_loadedPetForEdit!.photoUrl!), fit: BoxFit.cover)
                                      : null,
                            ),
                            child: (_pickedImageFile == null && (_isEditMode == false || _loadedPetForEdit?.photoUrl == null || _loadedPetForEdit!.photoUrl!.isEmpty))
                                ? Icon(Icons.pets, size: 80, color: Colors.grey[700])
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text('Gallery'),
                                onPressed: () => _pickImage(ImageSource.gallery),
                              ),
                              const SizedBox(width: 10),
                              TextButton.icon(
                                icon: const Icon(Icons.camera_alt_outlined),
                                label: const Text('Camera'),
                                onPressed: () => _pickImage(ImageSource.camera),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Pet Details', style: textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
                    const SizedBox(height: 16), // Adjusted spacing

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

              // Photo URL Field is now replaced by the image picker UI above.
              // We might want a way to clear/remove an existing photo without picking a new one.
              // This could be a small button next to the image preview if an image exists.
              // For V1 of image upload, we'll focus on picking/replacing.

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
