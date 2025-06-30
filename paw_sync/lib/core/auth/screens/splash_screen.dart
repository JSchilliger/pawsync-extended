// lib/core/auth/screens/splash_screen.dart
// This screen will be shown briefly when the app starts,
// potentially for loading initial data or checking auth state.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For ConsumerStatefulWidget
import 'package:go_router/go_router.dart';
import 'package:paw_sync/core/routing/app_router.dart'; // For AppRoutes

class SplashScreen extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for a short duration (e.g., for branding or initial checks)
    await Future.delayed(const Duration(seconds: 3));

    // Ensure the widget is still mounted before attempting to navigate
    if (mounted) {
      // Navigate to a common entry point, GoRouter's redirect will handle auth state.
      // Navigating to AppRoutes.login is a safe default. If the user is already
      // logged in, the redirect logic in app_router.dart will send them to home.
      // If not logged in, they'll land on the login screen.
      // Using context.go() for navigation as per go_router.
      GoRouter.of(context).go(AppRoutes.login);
      // Alternatively, could navigate to AppRoutes.home and let redirect handle if not logged in.
      // GoRouter.of(context).go(AppRoutes.home);
    }
  }

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
