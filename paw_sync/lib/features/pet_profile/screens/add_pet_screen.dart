// lib/features/pet_profile/screens/add_pet_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:paw_sync/core/auth/providers/auth_providers.dart'; // For currentUserIdProvider indirectly via pet_providers
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/features/pet_profile/providers/pet_providers.dart';
import 'package:paw_sync/core/widgets/themed_buttons.dart'; // Assuming this exists and is suitable

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _photoUrlController;
  DateTime? _selectedBirthDate;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _speciesController = TextEditingController();
    _breedController = TextEditingController();
    _photoUrlController = TextEditingController();
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
      setState(() {
        _isLoading = true;
      });

      final currentUserId = ref.read(currentUserIdProvider);
      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in. Cannot add pet.')),
        );
        setState(() { _isLoading = false; });
        return;
      }

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
        // Initialize other fields as needed, e.g., empty lists or null
        vaccinationRecords: [],
        medicalHistory: [],
      );

      try {
        // Use the addPetProvider from pet_providers.dart
        // addPetProvider is a simple Provider that returns a function.
        // This function, when called, executes the repository's addPet method
        // and handles provider invalidation.
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
        title: const Text('Add New Pet'),
      ),
      body: SingleChildScrollView(
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
                text: 'Save Pet',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
