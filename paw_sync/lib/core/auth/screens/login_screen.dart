// lib/core/auth/screens/login_screen.dart
// This screen will handle user login (Email/Password and Google Sign-In).

import 'package:flutter/material.dart';
import 'package:paw_sync/core/theme/theme.dart'; // Assuming AppColors and AppTextStyles are here

// Using StatefulWidget to manage Form key and basic field states if needed,
// but for a static placeholder, StatelessWidget is also fine.
// Let's stick with StatelessWidget for now as no actual state logic is implemented.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Dummy validator function (always returns null for now)
  String? _dummyValidator(String? value) {
    // if (value == null || value.isEmpty) {
    //   return 'This field is required';
    // }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar might be optional for a login screen, depending on design preference
      // appBar: AppBar(
      //   title: const Text('Login to Paw Sync'),
      //   elevation: 0, // Flat appbar
      //   backgroundColor: Colors.transparent, // Transparent appbar
      //   foregroundColor: AppColors.textPrimary, // Ensure title is visible
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Max width for form elements
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // App Logo Placeholder (e.g., an Icon or Image)
                  Icon(
                    Icons.pets, // Placeholder app logo
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Paw Sync!',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please sign in to continue',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                      // Using styles from theme.dart (via InputDecorationTheme)
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _dummyValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                      // Suffix icon for password visibility toggle (not implemented)
                      // suffixIcon: IconButton(
                      //   icon: Icon(Icons.visibility_off_outlined),
                      //   onPressed: () { /* Toggle password visibility */ },
                      // ),
                    ),
                    obscureText: true,
                    validator: _dummyValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password logic
                        print('Forgot password pressed');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      // backgroundColor: colorScheme.primary, // Already set by theme
                      // foregroundColor: colorScheme.onPrimary, // Already set by theme
                    ),
                    onPressed: () {
                      // TODO: Implement login logic
                      print('Login button pressed');
                    },
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 20),

                  // "Or sign in with" Divider
                  Row(
                    children: <Widget>[
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('Or sign in with', style: textTheme.bodySmall),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Google Sign-In Button
                  OutlinedButton.icon(
                    icon: Image.asset('assets/images/google_logo.png', height: 20.0, width: 20.0), // Placeholder for Google logo asset
                    // If you don't have the asset, use a generic icon:
                    // icon: const Icon(Icons.g_mobiledata, color: AppColors.textPrimary),
                    label: const Text('Sign In with Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      // foregroundColor: colorScheme.primary, // Already set by theme
                      // side: BorderSide(color: colorScheme.primary), // Already set by theme
                    ),
                    onPressed: () {
                      // TODO: Implement Google Sign-In logic
                      print('Google Sign-In button pressed');
                    },
                  ),
                  const SizedBox(height: 32),

                  // Sign Up Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?', style: textTheme.bodyMedium),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to Sign Up screen
                          print('Navigate to Sign Up');
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
