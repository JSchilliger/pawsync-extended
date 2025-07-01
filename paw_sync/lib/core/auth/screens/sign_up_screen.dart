// lib/core/auth/screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart';
import 'package:paw_sync/core/routing/app_router.dart';
import 'package:paw_sync/core/widgets/themed_buttons.dart'; // Assuming themed buttons are general enough
import 'package:paw_sync/core/auth/repositories/auth_repository.dart';


class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with sign up
      final displayName = _displayNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Call the auth notifier method
      await ref.read(authNotifierProvider.notifier).signUpWithEmailAndPassword(
            email,
            password,
            displayName: displayName.isNotEmpty ? displayName : null,
          );

      // After sign-up attempt, the authStateListenable in GoRouter should handle redirection
      // or the authNotifierProvider listener will show errors if any.
      // No explicit navigation here, rely on auth state changes.
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authNotifierProvider);

    // Listen to auth state for showing SnackBars on error
    ref.listen<AsyncValue>(
      authNotifierProvider,
      (previous, next) {
        if (next.hasError && !next.isLoading) {
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
        // Successful sign-up will trigger a navigation by GoRouter's redirect logic
        // based on auth state change, so no explicit success SnackBar needed here
        // unless we want to show one *before* navigation.
      },
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.person_add_alt_1_outlined, // Placeholder sign-up icon
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Create your Paw Sync Account',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join us to manage your pet\'s life!',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Display Name Field
                        TextFormField(
                          controller: _displayNameController,
                          decoration: InputDecoration(
                            labelText: 'Display Name (Optional)',
                            hintText: 'Your Name',
                            prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            // Optional field, no specific validation unless rules are set
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

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
                              onPressed: _togglePasswordVisibility,
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
                        const SizedBox(height: 20),

                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: colorScheme.primary,
                              ),
                              onPressed: _toggleConfirmPasswordVisibility,
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password.';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sign Up Button
                  PrimaryActionButton(
                    text: 'Sign Up',
                    isLoading: authState.isLoading,
                    onPressed: authState.isLoading ? null : _signUp,
                  ),
                  const SizedBox(height: 24),

                  // Sign In Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?', style: textTheme.bodyMedium),
                      TextButton(
                        onPressed: () {
                          if (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          } else {
                            GoRouter.of(context).go(AppRoutes.login);
                          }
                        },
                        child: Text(
                          'Sign In',
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
