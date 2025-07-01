// lib/features/pet_profile/widgets/save_grooming_preferences_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/core/widgets/themed_buttons.dart';

class SaveGroomingPreferencesForm extends ConsumerStatefulWidget {
  final GroomingPreferences? existingPreferences;
  final Function(GroomingPreferences) onSave;

  const SaveGroomingPreferencesForm({
    super.key,
    this.existingPreferences,
    required this.onSave,
  });

  @override
  ConsumerState<SaveGroomingPreferencesForm> createState() => _SaveGroomingPreferencesFormState();
}

class _SaveGroomingPreferencesFormState extends ConsumerState<SaveGroomingPreferencesForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _preferredGroomerController;
  late TextEditingController _cutStyleController;
  late TextEditingController _frequencyController;
  late TextEditingController _notesController;

  bool get _isEditMode => widget.existingPreferences != null;

  @override
  void initState() {
    super.initState();
    final prefs = widget.existingPreferences;
    _preferredGroomerController = TextEditingController(text: prefs?.preferredGroomer);
    _cutStyleController = TextEditingController(text: prefs?.cutStyle);
    _frequencyController = TextEditingController(text: prefs?.frequencyInWeeks?.toString());
    // Join list of notes into a single string for multiline TextField, separated by newlines.
    // If notes list is null or empty, initialize with an empty string.
    _notesController = TextEditingController(text: prefs?.notes?.join('\n') ?? '');
  }

  @override
  void dispose() {
    _preferredGroomerController.dispose();
    _cutStyleController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final frequencyText = _frequencyController.text.trim();
      final notesText = _notesController.text.trim();

      final newPreferences = GroomingPreferences(
        preferredGroomer: _preferredGroomerController.text.trim().isNotEmpty
            ? _preferredGroomerController.text.trim()
            : null,
        cutStyle: _cutStyleController.text.trim().isNotEmpty
            ? _cutStyleController.text.trim()
            : null,
        frequencyInWeeks: frequencyText.isNotEmpty
            ? int.tryParse(frequencyText)
            : null,
        // Split notes back into a list if not empty, otherwise null.
        notes: notesText.isNotEmpty ? notesText.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList() : null,
      );

      // Check if all fields are effectively null/empty. If so, treat as clearing preferences.
      // (This logic might need refinement based on desired "clear" behavior)
      bool allFieldsEmpty = (newPreferences.preferredGroomer == null || newPreferences.preferredGroomer!.isEmpty) &&
                            (newPreferences.cutStyle == null || newPreferences.cutStyle!.isEmpty) &&
                            newPreferences.frequencyInWeeks == null &&
                            (newPreferences.notes == null || newPreferences.notes!.isEmpty);

      // For V1, we always save the object. If all fields are empty, it's an object with nulls.
      // True deletion (setting pet.groomingPreferences to null) can be handled by a separate "Remove" button if needed.
      widget.onSave(newPreferences);
      Navigator.of(context).pop(); // Close the modal bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _isEditMode ? 'Edit Grooming Preferences' : 'Add Grooming Preferences',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _preferredGroomerController,
                decoration: const InputDecoration(labelText: 'Preferred Groomer (Optional)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cutStyleController,
                decoration: const InputDecoration(labelText: 'Cut Style (Optional)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(labelText: 'Frequency in Weeks (Optional)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (int.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number.';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Enter any grooming notes, one per line if desired.',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.newline, // Allows newlines
              ),
              const SizedBox(height: 24),
              PrimaryActionButton(
                text: _isEditMode ? 'Update Preferences' : 'Save Preferences',
                onPressed: _submitForm,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
