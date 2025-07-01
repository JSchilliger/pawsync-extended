// lib/core/screens/error_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For GoRouter.of(context).go

class ErrorScreen extends StatelessWidget {
  final Exception? error; // GoRouter provides the error in GoRouterState

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final String errorMessage = error is GoException ? (error as GoException).message : error?.toString() ?? "The page you requested could not be found.";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 20),
              Text(
                'Oops! Something went wrong.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Attempt to go to the home screen
                  // Using context.go to replace the current error route
                  GoRouter.of(context).go('/');
                },
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
