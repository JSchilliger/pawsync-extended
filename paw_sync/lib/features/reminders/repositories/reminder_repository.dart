// lib/features/reminders/repositories/reminder_repository.dart

import 'package:paw_sync/features/reminders/models/reminder_model.dart';

/// Abstract interface for a repository that manages reminder data.
abstract class ReminderRepository {
  /// Fetches a list of reminders for a given user, with optional filters.
  Future<List<ReminderModel>> getReminders({
    required String userId,
    DateTime? dueAfter, // Fetch reminders due after this date
    DateTime? dueBefore, // Fetch reminders due before this date
    bool? isCompleted,
    ReminderType? type,
    String? petId, // Filter by specific pet
    // TODO: Add pagination parameters (e.g., lastDocumentSnapshot, limit)
  });

  /// Fetches a single reminder by its ID.
  /// Returns null if the reminder is not found.
  Future<ReminderModel?> getReminderById(String reminderId);

  /// Adds a new reminder and returns its generated ID.
  Future<String> addReminder(ReminderModel reminder);

  /// Updates an existing reminder.
  Future<void> updateReminder(ReminderModel reminder);

  /// Deletes a reminder by its ID.
  Future<void> deleteReminder(String reminderId);
}

/// Custom exception for errors occurring in the ReminderRepository.
class ReminderRepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic underlyingException;

  ReminderRepositoryException(this.message, {this.code, this.underlyingException});

  @override
  String toString() {
    String result = 'ReminderRepositoryException: $message';
    if (code != null) {
      result += ' (Code: $code)';
    }
    if (underlyingException != null) {
      result += '\nUnderlying exception: $underlyingException';
    }
    return result;
  }
}
