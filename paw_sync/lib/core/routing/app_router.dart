// lib/core/routing/app_router.dart
// This file defines the application's routes using the go_router package.
// It centralizes all navigation logic.

import 'dart:async'; // For StreamSubscription

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart'; // Import auth providers
import 'package:paw_sync/core/auth/screens/login_screen.dart';
import 'package:paw_sync/core/auth/screens/splash_screen.dart';
import 'package:paw_sync/features/pet_profile/screens/pet_profile_screen.dart';
// TODO: Import other screens as they are created.

// Application route paths.
// Using a class for route names helps avoid typos and provides a single source of truth.
class AppRoutes {
  static const String splash = '/'; // Initial route
  static const String login = '/login';
  static const String home = '/home'; // Represents the main screen after login, e.g., pet profiles
  static const String signUp = '/signUp'; // Route for the sign-up screen
  // Add other route names here e.g.
  // static const String petDetails = '/pet/:id'; // Example with path parameter
}

// PlaceholderScreen is no longer needed here as we are using actual screen files.
// /// A placeholder screen.
// class PlaceholderScreen extends StatelessWidget {
//   final String title;
//   const PlaceholderScreen({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Center(child: Text('This is the $title screen.')),
//     );
//   }
// }

/// The route configuration for the application.
class AppRouter {
  /// Private constructor to prevent instantiation.
  AppRouter._();

  static GoRouter getRouter(WidgetRef ref) {
    // ValueNotifier to trigger GoRouter refresh when auth state changes.
    final authStateNotifier = ValueNotifier<AsyncValue<dynamic>>(const AsyncValue.loading());

    // Listen to the authNotifierProvider and update the ValueNotifier.
    // It's important to manage the subscription to avoid memory leaks.
    // This is often done in a StatefulWidget that owns the GoRouter,
    // but for a static getRouter, we might need a more careful approach
    // or accept that this subscription lives for the app's lifetime if not managed.
    // For simplicity here, we'll assume it's managed or short-lived for setup.
    // A more robust solution might involve a dedicated Riverpod provider for the router itself.
    final StreamSubscription<AsyncValue<dynamic>>? subscription = ref.listen<AsyncValue<dynamic>>(
      authNotifierProvider,
      (previous, next) {
        authStateNotifier.value = next;
      },
    );
    // Manually set the initial value for authStateNotifier
    // This replaces the need for `fireImmediately: true` which might not be available in older Riverpod.
    authStateNotifier.value = ref.read(authNotifierProvider);

    // Ensure the subscription is cancelled when the notifier is disposed.
    // This is tricky with a static getRouter. In a real app, the GoRouter
    // instance and this listener would typically be managed by a provider or StatefulWidget.
    // For now, this is a simplified setup. The ValueNotifier itself doesn't
    // strictly need disposal if it's only used by the refreshListenable here
    // and GoRouter handles its own lifecycle with the listenable.
    // authStateNotifier.addListener(() {
    //   if (authStateNotifier.disposed) { // Hypothetical check, ValueNotifier doesn't have `disposed`
    //     subscription?.cancel();
    //   }
    // });
    // A better way for cleanup might be to make GoRouter itself a provider that handles this.
    // ref.onDispose(() => subscription?.cancel()); // This would work if getRouter was part of a provider


    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      refreshListenable: authStateNotifier, // Re-evaluate routes on auth change
      redirect: (BuildContext context, GoRouterState state) {
        final authState = ref.read(authNotifierProvider); // Read current auth state
        final user = authState.value; // Actual user object or null
        final bool isLoggedIn = user != null;

        final String currentLocation = state.matchedLocation;
        final bool isSplashScreen = currentLocation == AppRoutes.splash;
        final bool isLoggingIn = currentLocation == AppRoutes.login;

        print('Router Redirect: isLoggedIn: $isLoggedIn, currentLocation: $currentLocation');

        // If on splash, let it do its thing (e.g., timed navigation)
        if (isSplashScreen) {
          return null;
        }

        // If not logged in and not trying to log in, redirect to login
        if (!isLoggedIn && !isLoggingIn) {
          print('Redirecting to ${AppRoutes.login}');
          return AppRoutes.login;
        }

        // If logged in and on the login page, redirect to home
        if (isLoggedIn && isLoggingIn) {
          print('Redirecting to ${AppRoutes.home}');
          return AppRoutes.home;
        }

        // No redirect needed
        return null;
      },
      routes: <RouteBase>[
        // Splash Screen Route
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splash, // Using actual route name
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),

        // Home Screen Route
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.home, // Using actual route name
          builder: (BuildContext context, GoRouterState state) {
            return const PetProfileScreen();
          },
        ),

        // Login Screen Route
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.login, // Using actual route name
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
      ],

      // TODO: Add an error builder for handling unknown routes gracefully.
      // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    );
  }
}
