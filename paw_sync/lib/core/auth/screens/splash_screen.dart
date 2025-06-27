// lib/core/auth/screens/splash_screen.dart
// This screen will be shown briefly when the app starts,
// potentially for loading initial data or checking auth state.

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic placeholder UI for the splash screen
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(), // Show a loading spinner
            SizedBox(height: 20),
            Text('Paw Sync'), // App name
            Text('Loading...'),    // Loading message
          ],
        ),
      ),
    );
  }
}
