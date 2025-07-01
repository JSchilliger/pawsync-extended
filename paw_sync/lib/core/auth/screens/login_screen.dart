// lib/core/auth/screens/login_screen.dart
// This screen will handle user login (Email/Password and Google Sign-In).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart'; // Import AuthNotifier provider
import 'package:paw_sync/core/auth/providers/auth_providers.dart';
import 'package:paw_sync/core/widgets/themed_buttons.dart'; // Using themed buttons
import 'package:go_router/go_router.dart'; // For GoRouter.of(context)
import 'package:paw_sync/core/routing/app_router.dart'; // For AppRoutes


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Dummy validator function (will be replaced with actual logic)
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
    final authState = ref.watch(authNotifierProvider); // Watch the auth state

    // Listen to auth state for showing SnackBars on error for general auth operations
    ref.listen<AsyncValue>(
      authNotifierProvider,
      (previous, next) {
        if (next.hasError && !next.isLoading) {
          // Avoid showing snackbar if it's a specific error handled elsewhere (e.g., dialog)
          // This is a general catch-all.
          final errorMessage = next.error is AuthRepositoryException
              ? (next.error as AuthRepositoryException).message
              : next.error.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
    );

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

                  // Form for email and password
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'you@example.com',
                            prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email address.';
                            }
                            // Basic email validation regex
                            final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters.';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showForgotPasswordDialog(context, ref),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  PrimaryActionButton(
                    text: 'Sign In',
                    isLoading: authState.isLoading,
                    onPressed: authState.isLoading ? null : () { // Disable while loading
                      if (_formKey.currentState?.validate() ?? false) {
                        ref.read(authNotifierProvider.notifier).signInWithEmailAndPassword(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                      }
                    },
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
                  SecondaryActionButton( // Using themed button
                    text: 'Sign In with Google',
                    // iconData: Icons.g_mobiledata, // Or a custom Google icon if available
                    onPressed: authState.isLoading ? null : () { // Disable while loading
                      ref.read(authNotifierProvider.notifier).signInWithGoogle();
                    },
                  ),
                  // Fallback if Image.asset fails for google_logo.png:
                  // OutlinedButton.icon(
                  //   icon: const Icon(Icons.g_mobiledata), // Fallback icon
                  //   label: const Text('Sign In with Google'),
                  //   style: OutlinedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(vertical: 12.0),
                  //   ),
                  //   onPressed: authState.isLoading ? null : () {
                  //     ref.read(authNotifierProvider.notifier).signInWithGoogle();
                  //   },
                  // ),
                  const SizedBox(height: 32),

                  // Sign Up Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?', style: textTheme.bodyMedium),
                      TextButton(
                        onPressed: () {
                          // Navigate to Sign Up screen (SignUpScreen and route to be created later)
                          GoRouter.of(context).push(AppRoutes.signUp);
                          print('Navigate to Sign Up screen (route: ${AppRoutes.signUp})');
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

  // Method to show the forgot password dialog
  void _showForgotPasswordDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Form(
            key: dialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Enter your email address below to receive password reset instructions.'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address.';
                    }
                    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton( // Using FilledButton for primary action in dialog
              child: const Text('Send Reset Email'),
              onPressed: () async {
                if (dialogFormKey.currentState?.validate() ?? false) {
                  final email = emailController.text.trim();
                  try {
                    // Call the method from AuthNotifier
                    // Note: We don't use ref.watch here as it's an action.
                    // The authNotifierProvider itself isn't directly tracking reset password state,
                    // so we directly call the method. Feedback is manual via SnackBar.
                    await ref.read(authNotifierProvider.notifier).sendPasswordResetEmail(email: email);

                    // Show SnackBar first, then pop. Ensure widget is still mounted.
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password reset email sent to $email. Please check your inbox (and spam folder).'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(dialogContext).pop(); // Close dialog AFTER showing SnackBar
                    }
                  } catch (e) {
                    final errorMessage = e is AuthRepositoryException ? e.message : e.toString();
                    // Show SnackBar first, then pop. Ensure widget is still mounted.
                    if (mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $errorMessage'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                      Navigator.of(dialogContext).pop(); // Close dialog AFTER showing SnackBar
                    }
                  } finally {
                     // Dispose the controller only if the button was pressed.
                     // If dialog dismissed otherwise, it won't be disposed here.
                     // For robust disposal, dialog content could be a StatefulWidget.
                     emailController.dispose();
                  }
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      // Ensure controller is disposed if dialog is dismissed by tapping outside
      // This is a bit of a safety net, primary disposal is in the 'Send Reset Email' onPressed.
      // However, to be absolutely sure, we can try to dispose it here,
      // but it might have already been disposed.
      // A more robust way would be to manage the controller's lifecycle with the dialog's state.
      // For this scope, this is a reasonable attempt.
      // emailController.dispose(); // This might cause an error if already disposed.
      // A simple way: just let it be, or use a StatefulWidget for the dialog content.
    });
  }
}
