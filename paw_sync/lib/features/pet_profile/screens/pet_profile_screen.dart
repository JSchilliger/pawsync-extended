// lib/features/pet_profile/screens/pet_profile_screen.dart
// This screen will display and manage pet profiles.
// For now, it serves as a placeholder "home" screen after login.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:paw_sync/core/auth/providers/auth_providers.dart';
import 'package:paw_sync/core/routing/app_router.dart'; // Import AppRoutes
import 'package:paw_sync/features/pet_profile/models/pet_model.dart';
import 'package:paw_sync/features/pet_profile/providers/pet_providers.dart';

class PetProfileScreen extends ConsumerWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final petsAsyncValue = ref.watch(currentUserPetsStreamProvider); // Watch the stream provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
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
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              print('Logout button pressed and signout attempted');
            },
          ),
        ],
      ),
      body: petsAsyncValue.when(
        data: (pets) {
          if (pets.isEmpty) {
            return _buildEmptyState(context, textTheme, colorScheme);
          }
          return _buildPetList(context, textTheme, colorScheme, pets);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Error loading pets: $error');
          print(stackTrace);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading your pets: $error', textAlign: TextAlign.center),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add pet screen
          GoRouter.of(context).push(AppRoutes.addPet);
          print('Add new pet FAB pressed, navigating to ${AppRoutes.addPet}');
        },
        label: const Text('Add Pet'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPetList(BuildContext context, TextTheme textTheme, ColorScheme colorScheme, List<Pet> pets) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // Navigate to pet detail screen
              GoRouter.of(context).pushNamed(AppRoutes.petDetail, pathParameters: {'petId': pet.id});
              print('Tapped on pet: ${pet.name}, navigating to details with ID: ${pet.id}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TODO: Replace with actual image loading (Image.network(pet.photoUrl!)) if photoUrl is available
                Container(
                  height: 180,
                  color: Colors.grey[300], // Placeholder color
                  child: pet.photoUrl != null && pet.photoUrl!.isNotEmpty
                      ? Image.network(
                          pet.photoUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.pets, size: 80, color: Colors.grey[700])),
                        )
                      : Center(child: Icon(Icons.pets, size: 80, color: Colors.grey[700])),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet.species} - ${pet.breed ?? 'N/A'}', // Handle null breed
                        style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigate to pet detail screen (same as onTap for card)
                           GoRouter.of(context).pushNamed(AppRoutes.petDetail, pathParameters: {'petId': pet.id});
                           print('View details for ${pet.name}, navigating with ID: ${pet.id}');
                        },
                        child: const Text('View Details'),
                      ),
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
