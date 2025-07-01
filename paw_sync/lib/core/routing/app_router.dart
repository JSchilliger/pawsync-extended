// lib/core/routing/app_router.dart
// This file defines the application's routes using the go_router package.
// It centralizes all navigation logic.

import 'dart:async'; // For StreamSubscription

import 'package:flutter/material.dart';
import 'package:paw_sync/features/pet_profile/models/pet_model.dart'; // Added Pet model import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart'; // Import auth providers
import 'package:paw_sync/core/auth/screens/login_screen.dart';
import 'package:paw_sync/core/auth/screens/sign_up_screen.dart'; // Import SignUpScreen
import 'package:paw_sync/core/auth/screens/splash_screen.dart';
import 'package:paw_sync/features/pet_profile/screens/save_pet_screen.dart'; // Renamed from add_pet_screen
import 'package:paw_sync/features/pet_profile/screens/pet_detail_screen.dart'; // Import PetDetailScreen
import 'package:paw_sync/features/pet_profile/screens/pet_profile_screen.dart';
import 'package:paw_sync/core/screens/notifications_screen.dart'; // Import NotificationsScreen
import 'package:paw_sync/core/screens/error_screen.dart'; // Import ErrorScreen
// TODO: Import other screens as they are created.

// Application route paths.
// Using a class for route names helps avoid typos and provides a single source of truth.
class AppRoutes {
  static const String splash = '/'; // Initial route
  static const String login = '/login';
  static const String home = '/home'; // Represents the main screen after login, e.g., pet profiles
  static const String signUp = '/signUp'; // Route for the sign-up screen
  static const String addPet = '/add-pet'; // Route for adding a new pet
  static const String petDetail = '/pet/:petId'; // Route for viewing pet details
  static const String editPet = '/pet/:petId/edit'; // Route for editing a pet
  static const String notifications = '/notifications'; // Route for notifications
  // Add other route names here e.g.
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
    // The StreamSubscription is not stored as its lifecycle isn't easily managed in this static context.
    ref.listen<AsyncValue<dynamic>>(
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
        final bool isSigningUp = currentLocation == AppRoutes.signUp; // Check if on sign-up route

        print('Router Redirect: isLoggedIn: $isLoggedIn, currentLocation: $currentLocation');

        // If on splash, let it do its thing (e.g., timed navigation)
        if (isSplashScreen) {
          return null;
        }

        // If not logged in, not trying to log in, and not trying to sign up, redirect to login
        if (!isLoggedIn && !isLoggingIn && !isSigningUp) {
          print('Redirecting to ${AppRoutes.login}');
          return AppRoutes.login;
        }

        // If logged in and on the login or sign up page, redirect to home
        if (isLoggedIn && (isLoggingIn || isSigningUp)) {
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

        // Sign Up Screen Route
        GoRoute(
          path: AppRoutes.signUp,
          name: AppRoutes.signUp, // Using actual route name
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpScreen(); // Use the new SignUpScreen
          },
        ),

        // Add Pet Screen Route
        GoRoute(
          path: AppRoutes.addPet,
          name: AppRoutes.addPet,
          builder: (BuildContext context, GoRouterState state) {
            // Navigating to SavePetScreen in "Add Mode" (no petIdForEdit)
            return const SavePetScreen();
          },
          // This route should only be accessible if logged in.
          // The main redirect logic already handles redirecting to login if not authenticated.
          // If specific parent-child navigation is needed (e.g. /home/add-pet),
          // this could be a sub-route of AppRoutes.home. For now, a top-level route is fine.
        ),

        // Pet Detail Screen Route
        GoRoute(
          path: AppRoutes.petDetail, // e.g., /pet/123
          name: AppRoutes.petDetail,
          builder: (BuildContext context, GoRouterState state) {
            final petId = state.pathParameters['petId'];
            if (petId == null) {
              // This case should ideally not happen if path is matched correctly
              // and parameter is always present.
              // You could redirect to an error page or home.
              print('Error: petId is null for petDetail route');
              return const Scaffold(body: Center(child: Text('Error: Pet ID missing')));
            }
            return PetDetailScreen(petId: petId);
          },
          // This route should only be accessible if logged in.
          // The main redirect logic already handles this.
        ),

        // Edit Pet Screen Route
        GoRoute(
          path: AppRoutes.editPet, // e.g., /pet/123/edit
          name: AppRoutes.editPet,
          builder: (BuildContext context, GoRouterState state) {
            final petId = state.pathParameters['petId'];
            final Pet? pet = state.extra as Pet?; // Receive the Pet object as an extra

            if (petId == null) {
              print('Error: petId is null for editPet route');
              return const Scaffold(body: Center(child: Text('Error: Pet ID missing for edit')));
            }
            // Pass petId for fetching if needed, and pet as initialData
            return SavePetScreen(petIdForEdit: petId, initialPetData: pet);
          },
        ),

        // Notifications Screen Route
        GoRoute(
          path: AppRoutes.notifications,
          name: AppRoutes.notifications,
          builder: (BuildContext context, GoRouterState state) {
            return const NotificationsScreen();
          },
          // This route should only be accessible if logged in.
          // The main redirect logic already handles this.
        ),
      ],

      errorBuilder: (context, state) => ErrorScreen(error: state.error),
      // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    );
  }
}
