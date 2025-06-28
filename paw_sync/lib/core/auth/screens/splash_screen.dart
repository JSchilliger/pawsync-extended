// lib/core/auth/screens/splash_screen.dart
// This screen will be shown briefly when the app starts,
// potentially for loading initial data or checking auth state.

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea( // Added SafeArea
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Placeholder App Logo
              Icon(
                Icons.pets, // Placeholder app logo icon
                size: 80,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Paw Sync',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
