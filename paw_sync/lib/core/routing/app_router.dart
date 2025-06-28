// lib/core/routing/app_router.dart
// This file defines the application's routes using the go_router package.
// It centralizes all navigation logic.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Required for using Riverpod with GoRouter redirect
import 'package:go_router/go_router.dart';
// import 'package:paw_sync/core/auth/providers/auth_providers.dart'; // Import auth providers
// import 'package:paw_sync/core/auth/screens/login_screen.dart';
// import 'package:paw_sync/core/auth/screens/splash_screen.dart';
// import 'package:paw_sync/features/pet_profile/screens/pet_profile_screen.dart'; // Placeholder Home

// TODO: Import other screens as they are created.

// Application route paths.
// Using a class for route names helps avoid typos and provides a single source of truth.
class AppRoutes {
  static const String splash = '/'; // Initial route
  static const String login = '/login'; // Commented out for now
  static const String home = '/home'; // Represents the main screen after login, e.g., pet profiles
  // Add other route names here e.g.
  // static const String petDetails = '/pet/:id'; // Example with path parameter
}

/// A placeholder screen.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title screen.')),
    );
  }
}

/// The route configuration for the application.
class AppRouter {
  /// Private constructor to prevent instantiation.
  AppRouter._();

  // GoRouter configuration
  static GoRouter getRouter(WidgetRef ref) {
    // final authState = ref.watch(authStateChangesProvider); // Commented out auth-dependent redirect

    return GoRouter(
      initialLocation: AppRoutes.splash, // Start with splash or a simple home
      debugLogDiagnostics: true, // Log diagnostic info for GoRouter. Disable in production.

      // redirect: (BuildContext context, GoRouterState state) { // Commented out auth-dependent redirect
      //   final bool loggedIn = authState.asData?.value != null;
      //   final String currentLocation = state.matchedLocation;

      //   print("Redirect check: LoggedIn: $loggedIn, CurrentLocation: $currentLocation");

      //   if (currentLocation == AppRoutes.splash) {
      //     return null;
      //   }

      //   if (!loggedIn && currentLocation != AppRoutes.login) {
      //     print("Redirecting to login");
      //     return AppRoutes.login;
      //   }

      //   if (loggedIn && currentLocation == AppRoutes.login) {
      //     print("Redirecting to home");
      //     return AppRoutes.home;
      //   }
      //   print("No redirect needed for location: $currentLocation");
      //   return null;
      // },

      routes: <RouteBase>[
        // Simplified Splash Screen Route to a Placeholder
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash_placeholder', // Changed name to avoid conflict if original splash is restored
          builder: (BuildContext context, GoRouterState state) {
            // For now, SplashScreen is not defined, use a placeholder
            return const PlaceholderScreen(title: "Splash Screen");
          },
        ),

        // Simplified Home Screen Route
        GoRoute(
          path: AppRoutes.home,
          name: 'home_placeholder', // Changed name to avoid conflict if original home is restored
          builder: (BuildContext context, GoRouterState state) {
            // For now, PetProfileScreen is not defined, use a placeholder
            return const PlaceholderScreen(title: "Home Screen");
          },
        ),

        // Login Screen Route (Commented out as LoginScreen is not defined yet)
        // GoRoute(
        //   path: AppRoutes.login,
        //   name: AppRoutes.login,
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const LoginScreen();
        //   },
        // ),
      ],

      // TODO: Add an error builder for handling unknown routes gracefully.
      // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    );
  }
}
