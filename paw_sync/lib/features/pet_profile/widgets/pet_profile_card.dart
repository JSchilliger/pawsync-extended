// lib/features/pet_profile/widgets/pet_profile_card.dart
// Placeholder widget for displaying a summary of a pet's profile.

import 'package:flutter/material.dart';

class PetProfileCard extends StatelessWidget {
  const PetProfileCard({super.key, required this.petName});

  final String petName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              petName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Species: Placeholder'),
            const Text('Breed: Placeholder'),
            // Add more pet summary details here
          ],
        ),
      ),
    );
  }
}
