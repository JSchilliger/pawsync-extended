// lib/core/routing/app_router.dart
// This file defines the application's routes using the go_router package.
// It centralizes all navigation logic.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Required for using Riverpod with GoRouter redirect
import 'package:go_router/go_router.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart'; // Import auth providers
import 'package:paw_sync/core/auth/screens/login_screen.dart';
import 'package:paw_sync/core/auth/screens/splash_screen.dart';
import 'package:paw_sync/features/pet_profile/screens/pet_profile_screen.dart'; // Placeholder Home

// TODO: Import other screens as they are created.

// Application route paths.
// Using a class for route names helps avoid typos and provides a single source of truth.
class AppRoutes {
  static const String splash = '/'; // Initial route
  static const String login = '/login';
  static const String home = '/home'; // Represents the main screen after login, e.g., pet profiles
  // Add other route names here e.g.
  // static const String petDetails = '/pet/:id'; // Example with path parameter
}

/// The route configuration for the application.
class AppRouter {
  /// Private constructor to prevent instantiation.
  AppRouter._();

  // GoRouter configuration
  // It's important to pass the ProviderContainer to GoRouter if you plan to use
  // Riverpod providers within redirect or other GoRouter callbacks.
  // However, for simplicity in this initial setup, we'll make the redirect logic
  // depend on a WidgetRef being available, which means redirect might be better handled
  // by a top-level listening widget or directly within SplashScreen for initial routing.
  // For a cleaner approach, a refreshListenable based on authStateChangesProvider is often used.

  static GoRouter getRouter(WidgetRef ref) {
    // Listen to the auth state to trigger redirects when it changes.
    // This is one way to handle auth state changes for redirection.
    // Another way is to use a refreshListenable with a ValueNotifier that updates based on auth state.
    final authState = ref.watch(authStateChangesProvider);

    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true, // Log diagnostic info for GoRouter. Disable in production.

      // refreshListenable: ValueNotifier<User?>(authState.asData?.value), // This needs a proper setup with a ValueNotifier

      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authState.asData?.value != null;
        final String currentLocation = state.matchedLocation;

        print("Redirect check: LoggedIn: $loggedIn, CurrentLocation: $currentLocation");

        // If on splash screen, let it decide (usually navigates after a delay or check)
        if (currentLocation == AppRoutes.splash) {
          return null; // SplashScreen will handle navigation
        }

        // If not logged in and not trying to log in, redirect to login.
        if (!loggedIn && currentLocation != AppRoutes.login) {
          print("Redirecting to login");
          return AppRoutes.login;
        }

        // If logged in and on the login page, redirect to home.
        if (loggedIn && currentLocation == AppRoutes.login) {
          print("Redirecting to home");
          return AppRoutes.home;
        }

        // No redirect needed
        print("No redirect needed for location: $currentLocation");
        return null;
      },

      routes: <RouteBase>[
        // Splash Screen Route
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splash,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),

        // Login Screen Route
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),

        // Home Screen Route (Pet Profile Screen as placeholder)
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.home,
          builder: (BuildContext context, GoRouterState state) {
            return const PetProfileScreen();
          },
          // Example of a redirect guard directly on a route, if needed:
          // redirect: (BuildContext context, GoRouterState state) {
          //   if (!ref.read(isLoggedInProvider)) { // Simpler check if not using async redirect
          //     return AppRoutes.login;
          //   }
          //   return null;
          // },
        ),
      ],

      // TODO: Add an error builder for handling unknown routes gracefully.
      // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    );
  }
}
