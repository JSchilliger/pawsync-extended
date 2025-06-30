// lib/features/reminders/models/reminder_model.dart

import 'package:flutter/foundation.dart';
import 'package:paw_sync/core/utils/enums.dart'; // Import centralized enums

/// Represents a reminder for a pet or user.
@immutable
class ReminderModel {
  final String id; // Unique identifier for the reminder
  final String userId; // User to whom this reminder belongs
  final String? petId; // Optional: Pet this reminder is associated with
  final String title;
  final String? notes;
  final DateTime dueDate;
  final bool isCompleted;
  final ReminderType type;
  final String? recurringRule; // e.g., 'every_day', 'every_week_monday', 'every_2_months_on_15th'
                               // Could be a more structured map: {'frequency': 'weekly', 'dayOfWeek': 'monday'}

  const ReminderModel({
    required this.id,
    required this.userId,
    this.petId,
    required this.title,
    this.notes,
    required this.dueDate,
    this.isCompleted = false,
    required this.type,
    this.recurringRule,
  });

  ReminderModel copyWith({
    String? id,
    String? userId,
    String? petId,
    String? title,
    String? notes,
    DateTime? dueDate,
    bool? isCompleted,
    ReminderType? type,
    String? recurringRule,
    bool setPetIdToNull = false, // Special flag to explicitly set petId to null
  }) {
    return ReminderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      petId: setPetIdToNull ? null : (petId ?? this.petId),
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      recurringRule: recurringRule ?? this.recurringRule,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'petId': petId,
      'title': title,
      'notes': notes,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'type': reminderTypeToString(type),
      'recurringRule': recurringRule,
    };
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      petId: json['petId'] as String?,
      title: json['title'] as String,
      notes: json['notes'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      type: reminderTypeFromString(json['type'] as String? ?? ReminderType.other.name),
      recurringRule: json['recurringRule'] as String?,
    );
  }

  @override
  String toString() {
    return 'ReminderModel(id: $id, userId: $userId, petId: $petId, title: $title, notes: $notes, dueDate: $dueDate, isCompleted: $isCompleted, type: $type, recurringRule: $recurringRule)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReminderModel &&
        other.id == id &&
        other.userId == userId &&
        other.petId == petId &&
        other.title == title &&
        other.notes == notes &&
        other.dueDate == dueDate &&
        other.isCompleted == isCompleted &&
        other.type == type &&
        other.recurringRule == recurringRule;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        petId.hashCode ^
        title.hashCode ^
        notes.hashCode ^
        dueDate.hashCode ^
        isCompleted.hashCode ^
        type.hashCode ^
        recurringRule.hashCode;
  }
}
