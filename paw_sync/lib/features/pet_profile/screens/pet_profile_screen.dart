// lib/features/pet_profile/screens/pet_profile_screen.dart
// This screen will display and manage pet profiles.
// For now, it serves as a placeholder "home" screen after login.

import 'package:flutter/material.dart';
// import 'package:paw_sync/features/pet_profile/models/pet_model.dart'; // For Pet type, if used directly

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  // Placeholder data for pet cards - in a real app, this would come from a provider
  final List<Map<String, String>> _placeholderPets = const [
    {
      'name': 'Buddy',
      'species': 'Dog',
      'breed': 'Golden Retriever',
      'photoPlaceholder': 'assets/images/dog_placeholder.png', // Needs asset
    },
    {
      'name': 'Whiskers',
      'species': 'Cat',
      'breed': 'Siamese',
      'photoPlaceholder': 'assets/images/cat_placeholder.png', // Needs asset
    },
    {
      'name': 'Rocky',
      'species': 'Dog',
      'breed': 'German Shepherd',
      'photoPlaceholder': 'assets/images/dog_placeholder_2.png', // Needs asset
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final bool hasPets = _placeholderPets.isNotEmpty; // Simulate having pets or not

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'), // Changed title
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            tooltip: 'Notifications',
            onPressed: () {
              // TODO: Navigate to notifications screen or show dialog
              print('Notifications icon pressed');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Logout',
            onPressed: () {
              // TODO: Implement logout logic and navigate to LoginScreen
              print('Logout button pressed');
              // Example: ref.read(signOutProvider)(); // Using a provider
              // context.go(AppRoutes.login); // Using GoRouter
            },
          ),
        ],
      ),
      body: hasPets ? _buildPetList(context, textTheme, colorScheme) : _buildEmptyState(context, textTheme, colorScheme),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add pet screen
          print('Add new pet FAB pressed');
        },
        label: const Text('Add Pet'),
        icon: const Icon(Icons.add),
        // backgroundColor: colorScheme.secondary, // Or primary
        // foregroundColor: colorScheme.onSecondary, // Or onPrimary
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPetList(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _placeholderPets.length,
      itemBuilder: (context, index) {
        final pet = _placeholderPets[index];
        return Card(
          // elevation: Theme.of(context).cardTheme.elevation ?? 4.0, // From theme
          // shape: Theme.of(context).cardTheme.shape, // From theme
          // margin: Theme.of(context).cardTheme.margin, // From theme
          clipBehavior: Clip.antiAlias, // Ensures content respects card shape
          child: InkWell(
            onTap: () {
              // TODO: Navigate to pet detail screen
              print('Tapped on pet: ${pet['name']}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Placeholder for Pet Image
                Container(
                  height: 180,
                  color: Colors.grey[300], // Placeholder color
                  // child: Image.asset(
                  //   pet['photoPlaceholder']!,
                  //   fit: BoxFit.cover,
                  //   errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.pets, size: 50, color: Colors.grey[600])),
                  // ),
                  // If assets are not available, use an icon:
                  child: Center(child: Icon(Icons.pets, size: 80, color: Colors.grey[700])),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet['name']!,
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet['species']} - ${pet['breed']}',
                        style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                // Example actions on a pet card
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          print('View details for ${pet['name']}');
                        },
                        child: const Text('View Details'),
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                      //   onPressed: () { print('Edit ${pet['name']}'); },
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.pets_outlined, // Or a custom empty state illustration
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Pets Yet!',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you haven\'t added any pets. Tap the "Add Pet" button below to get started.',
              style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
