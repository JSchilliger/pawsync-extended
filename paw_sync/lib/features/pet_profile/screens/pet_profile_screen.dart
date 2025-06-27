// lib/features/pet_profile/screens/pet_profile_screen.dart
// This screen will display and manage pet profiles.
// For now, it serves as a placeholder "home" screen after login.

import 'package:flutter/material.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic placeholder UI for the Pet Profile screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Profiles (Home)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add pet screen or show a dialog
              print('Add new pet');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement logout logic and navigate to LoginScreen
              print('Logout button pressed');
              // Example: context.go('/login'); // Requires GoRouter setup
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Pet Profile Screen',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder action
              },
              child: const Text('View My Pets'),
            ),
          ],
        ),
      ),
    );
  }
}
