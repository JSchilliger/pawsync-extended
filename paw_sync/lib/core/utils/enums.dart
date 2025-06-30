// lib/core/utils/enums.dart

// --- Business Enums ---
enum BusinessType { vet, groomer, sitter, store, park, other }

String businessTypeToString(BusinessType type) => type.toString().split('.').last;
BusinessType businessTypeFromString(String typeString) {
  return BusinessType.values.firstWhere(
    (e) => e.toString().split('.').last == typeString,
    orElse: () => BusinessType.other,
  );
}

// --- Reminder Enums ---
enum ReminderType {
  vaccine,
  grooming,
  medication,
  vetAppointment,
  feeding,
  general,
  other,
}

String reminderTypeToString(ReminderType type) => type.toString().split('.').last;
ReminderType reminderTypeFromString(String typeString) {
  return ReminderType.values.firstWhere(
    (e) => e.toString().split('.').last == typeString,
    orElse: () => ReminderType.other,
  );
}

// --- User Settings Enums ---
enum ThemePreference {
  system,
  light,
  dark,
}

String themePreferenceToString(ThemePreference type) => type.toString().split('.').last;
ThemePreference themePreferenceFromString(String typeString) {
  return ThemePreference.values.firstWhere(
    (e) => e.toString().split('.').last == typeString,
    orElse: () => ThemePreference.system,
  );
}

// --- Pet Enums ---
enum PetSpecies {
  dog,
  cat,
  bird,
  reptile,
  smallAnimal, // e.g., hamster, guinea pig
  fish,
  other,
}

String petSpeciesToString(PetSpecies type) => type.toString().split('.').last;
PetSpecies petSpeciesFromString(String typeString) {
  // Consider case-insensitivity for robustness if input strings might vary
  final lowerTypeString = typeString.toLowerCase();
  return PetSpecies.values.firstWhere(
    (e) => e.toString().split('.').last.toLowerCase() == lowerTypeString,
    orElse: () => PetSpecies.other,
  );
}
