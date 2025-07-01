// lib/features/pet_profile/widgets/save_medical_event_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/core/widgets/themed_buttons.dart';
import 'package:uuid/uuid.dart'; // To generate unique IDs for new events

class SaveMedicalEventForm extends ConsumerStatefulWidget {
  final Pet pet;
  final MedicalEvent? existingEvent;
  final Function(MedicalEvent) onSave;

  const SaveMedicalEventForm({
    super.key,
    required this.pet,
    this.existingEvent,
    required this.onSave,
  });

  @override
  ConsumerState<SaveMedicalEventForm> createState() => _SaveMedicalEventFormState();
}

class _SaveMedicalEventFormState extends ConsumerState<SaveMedicalEventForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventTypeController;
  late TextEditingController _descriptionController;
  late TextEditingController _veterinarianController;
  DateTime? _eventDate;

  bool get _isEditMode => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();
    _eventTypeController = TextEditingController(text: widget.existingEvent?.type);
    _descriptionController = TextEditingController(text: widget.existingEvent?.description);
    _veterinarianController = TextEditingController(text: widget.existingEvent?.veterinarianOrClinic);
    _eventDate = widget.existingEvent?.date;
  }

  @override
  void dispose() {
    _eventTypeController.dispose();
    _descriptionController.dispose();
    _veterinarianController.dispose();
    super.dispose();
  }

  Future<void> _pickEventDate(BuildContext context) async {
    final initialDate = _eventDate ?? DateTime.now();
    final firstDate = DateTime(1980); // Arbitrary past date
    final lastDate = DateTime.now();   // Event cannot happen in the future

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_eventDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select the event date.')),
        );
        return;
      }

      final String eventId = _isEditMode ? widget.existingEvent!.id : const Uuid().v4();

      final newEvent = MedicalEvent(
        id: eventId,
        type: _eventTypeController.text.trim(),
        date: _eventDate!,
        description: _descriptionController.text.trim(),
        veterinarianOrClinic: _veterinarianController.text.trim().isNotEmpty
            ? _veterinarianController.text.trim()
            : null,
        attachmentUrls: _isEditMode ? widget.existingEvent?.attachmentUrls : null, // Preserve existing attachments
      );
      widget.onSave(newEvent);
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
                _isEditMode ? 'Edit Medical Event' : 'Add Medical Event',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _eventTypeController,
                decoration: const InputDecoration(labelText: 'Event Type (e.g., Vet Visit, Procedure)'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the event type.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date of Event',
                  hintText: 'Select Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _eventDate == null ? '' : DateFormat.yMMMd().format(_eventDate!),
                ),
                onTap: () => _pickEventDate(context),
                 validator: (value) {
                  if (_eventDate == null) {
                    return 'Please select the event date.';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true, // Good for multiline
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description for the event.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _veterinarianController,
                decoration: const InputDecoration(labelText: 'Veterinarian/Clinic (Optional)'),
              ),
              // TODO: Add UI for managing attachmentUrls in a future iteration
              const SizedBox(height: 24),
              PrimaryActionButton(
                text: _isEditMode ? 'Update Event' : 'Add Event',
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
