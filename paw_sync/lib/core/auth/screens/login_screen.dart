// lib/core/auth/screens/login_screen.dart
// This screen will handle user login (Email/Password and Google Sign-In).

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic placeholder UI for the login screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Paw Sync'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Paw Sync',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // Placeholder for Email Field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Placeholder for Password Field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              // Placeholder for Login Button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login logic
                  print('Login button pressed');
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              // Placeholder for Google Sign-In Button
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata), // Placeholder for Google icon
                label: const Text('Sign in with Google'),
                onPressed: () {
                  // TODO: Implement Google Sign-In logic
                  print('Google Sign-In button pressed');
                },
              ),
              // Placeholder for "Don't have an account? Sign up"
              TextButton(
                onPressed: () {
                  // TODO: Navigate to Sign Up screen
                  print('Navigate to Sign Up');
                },
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
