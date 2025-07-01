// lib/features/pet_profile/widgets/save_vaccination_record_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/core/widgets/themed_buttons.dart'; // Assuming this exists

class SaveVaccinationRecordForm extends ConsumerStatefulWidget {
  final Pet pet;
  final VaccinationRecord? existingRecord;
  final Function(VaccinationRecord) onSave;

  const SaveVaccinationRecordForm({
    super.key,
    required this.pet,
    this.existingRecord,
    required this.onSave,
  });

  @override
  ConsumerState<SaveVaccinationRecordForm> createState() => _SaveVaccinationRecordFormState();
}

class _SaveVaccinationRecordFormState extends ConsumerState<SaveVaccinationRecordForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _vaccineNameController;
  late TextEditingController _veterinarianController;
  DateTime? _dateAdministered;
  DateTime? _nextDueDate;

  bool get _isEditMode => widget.existingRecord != null;

  @override
  void initState() {
    super.initState();
    _vaccineNameController = TextEditingController(text: widget.existingRecord?.vaccineName);
    _veterinarianController = TextEditingController(text: widget.existingRecord?.veterinarian);
    _dateAdministered = widget.existingRecord?.dateAdministered;
    _nextDueDate = widget.existingRecord?.nextDueDate;
  }

  @override
  void dispose() {
    _vaccineNameController.dispose();
    _veterinarianController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isAdministeredDate) async {
    final initialDate = (isAdministeredDate ? _dateAdministered : _nextDueDate) ?? DateTime.now();
    final firstDate = DateTime(1980);
    final lastDate = isAdministeredDate ? DateTime.now() : DateTime(2100); // Next due can be in future

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        if (isAdministeredDate) {
          _dateAdministered = picked;
        } else {
          _nextDueDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_dateAdministered == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select the date administered.')),
        );
        return;
      }

      final newRecord = VaccinationRecord(
        vaccineName: _vaccineNameController.text.trim(),
        dateAdministered: _dateAdministered!,
        nextDueDate: _nextDueDate,
        veterinarian: _veterinarianController.text.trim().isNotEmpty
            ? _veterinarianController.text.trim()
            : null,
      );
      widget.onSave(newRecord);
      Navigator.of(context).pop(); // Close the modal bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Important for bottom sheet
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _isEditMode ? 'Edit Vaccination Record' : 'Add Vaccination Record',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _vaccineNameController,
                decoration: const InputDecoration(labelText: 'Vaccine Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the vaccine name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date Administered',
                  hintText: 'Select Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _dateAdministered == null ? '' : DateFormat.yMMMd().format(_dateAdministered!),
                ),
                onTap: () => _pickDate(context, true),
                validator: (value) { // Technically covered by _dateAdministered null check in _submitForm
                  if (_dateAdministered == null) {
                    return 'Please select the date administered.';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Next Due Date (Optional)',
                  hintText: 'Select Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _nextDueDate == null ? '' : DateFormat.yMMMd().format(_nextDueDate!),
                ),
                onTap: () => _pickDate(context, false),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _veterinarianController,
                decoration: const InputDecoration(labelText: 'Veterinarian (Optional)'),
              ),
              const SizedBox(height: 24),
              PrimaryActionButton(
                text: _isEditMode ? 'Update Record' : 'Add Record',
                onPressed: _submitForm,
              ),
              const SizedBox(height: 16), // Padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
