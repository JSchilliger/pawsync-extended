// test/widgets/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth; // Alias
import 'package:paw_sync/core/auth/notifiers/auth_notifier.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart';
import 'package:paw_sync/core/auth/screens/login_screen.dart';
import 'package:paw_sync/core/theme/theme.dart'; // To provide theme

// This will use the existing mock generator setup if AuthNotifier is added there,
// or generate a new one. For simplicity, let's assume we need a specific mock for the Notifier itself.
// User must run: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([AuthNotifier]) // Mocking the Notifier itself
import 'login_screen_test.mocks.dart'; // Will be generated

// A mock AuthNotifier subclass to control its state for widget tests
class MockAuthNotifierSubclass extends Mock implements AuthNotifier {}


void main() {
  late MockAuthNotifier mockAuthNotifier;

  setUp(() {
    mockAuthNotifier = MockAuthNotifier();
    // Default stub for the state, can be overridden in specific tests
    when(mockAuthNotifier.state).thenReturn(const AsyncData<fb_auth.User?>(null));
    // For methods that return Future<void> and are called by ref.read().notifier.method()
    when(mockAuthNotifier.signInWithEmailAndPassword(any, any)).thenAnswer((_) async {});
    when(mockAuthNotifier.signInWithGoogle()).thenAnswer((_) async {});
    when(mockAuthNotifier.sendPasswordResetEmail(email: anyNamed('email'))).thenAnswer((_) async {});

  });

  // Helper to pump the widget with necessary providers
  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override the authNotifierProvider to return our mock
          // We need to provide an instance of the *actual* notifier type that then uses the mock internally,
          // or ensure the mock *is* the notifier type.
          // For AsyncNotifierProvider, it's trickier. Let's mock the notifier methods directly.
          // The way AuthNotifier is structured, its methods are called on .notifier.
          // So we provide a mock that *is* an AuthNotifier.
           authNotifierProvider.overrideWith((ref) => mockAuthNotifier)
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme, // Provide the app's theme
          home: const LoginScreen(),
          // It's good practice to also wrap with a Navigator if GoRouter.of(context) is used
          // For LoginScreen, GoRouter.of(context).push(AppRoutes.signUp) is used.
          // So we need a mock Navigator or a simple MaterialApp with a home that has a Navigator.
          // Adding a simple Navigator:
          // home: const Navigator(onGenerateRoute: ...), // This gets complex quickly
          // Easiest is to use MaterialApp which includes a Navigator.
        ),
      ),
    );
  }

  testWidgets('LoginScreen displays essential UI elements', (WidgetTester tester) async {
    // Arrange: Default state is AsyncData(null) (no user, not loading)
    // This is handled by the global setUp and default when(mockAuthNotifier.state)

    // Act
    await pumpLoginScreen(tester);

    // Assert
    // Check for Welcome text (can be more specific if needed)
    expect(find.textContaining('Welcome to Paw Sync!'), findsOneWidget);
    expect(find.text('Please sign in to continue'), findsOneWidget);

    // Check for Email and Password fields
    expect(find.widgetWithText(TextFormField, 'Email Address'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

    // Check for Sign In button
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget); // Assuming PrimaryActionButton renders an ElevatedButton

    // Check for "Or sign in with" divider text
    expect(find.text('Or sign in with'), findsOneWidget);

    // Check for Google Sign-In button
    // Assuming SecondaryActionButton renders an OutlinedButton or similar with this text
    expect(find.widgetWithText(OutlinedButton, 'Sign In with Google'), findsOneWidget);

    // Check for "Forgot Password?" button
    expect(find.widgetWithText(TextButton, 'Forgot Password?'), findsOneWidget);

    // Check for Sign Up navigation
    expect(find.text("Don't have an account?"), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Sign Up'), findsOneWidget);
  });

  testWidgets('LoginScreen shows loading indicator when auth state is loading', (WidgetTester tester) async {
    // Arrange
    when(mockAuthNotifier.state).thenReturn(const AsyncLoading<fb_auth.User?>());

    // Act
    await pumpLoginScreen(tester);
    await tester.pump(); // Process the state change

    // Assert
    // Sign In button should be disabled (or show loading)
    // PrimaryActionButton has an isLoading property. We need to check if it's passed correctly.
    // Let's assume PrimaryActionButton renders an ElevatedButton and its onPressed is null when isLoading.
    final signInButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Sign In'));
    expect(signInButton.onPressed, isNull);

    // Google Sign In button should also be disabled
    final googleSignInButton = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Sign In with Google'));
    expect(googleSignInButton.onPressed, isNull);

    // Alternatively, if your buttons show a CircularProgressIndicator when loading:
    // expect(find.byType(CircularProgressIndicator), findsOneWidget); // This might be too broad
  });

  testWidgets('Tapping Sign In button calls signInWithEmailAndPassword', (WidgetTester tester) async {
    // Arrange
    // Default state is AsyncData(null)
    await pumpLoginScreen(tester);

    // Enter text into email and password fields
    await tester.enterText(find.widgetWithText(TextFormField, 'Email Address'), 'test@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.pump();

    // Act
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pump(); // Allow time for futures to complete if any

    // Assert
    verify(mockAuthNotifier.signInWithEmailAndPassword('test@example.com', 'password123')).called(1);
  });

  testWidgets('Tapping Google Sign In button calls signInWithGoogle', (WidgetTester tester) async {
    // Arrange
    await pumpLoginScreen(tester);

    // Act
    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign In with Google'));
    await tester.pump();

    // Assert
    verify(mockAuthNotifier.signInWithGoogle()).called(1);
  });

  testWidgets('Forgot Password dialog appears and calls sendPasswordResetEmail', (WidgetTester tester) async {
    await pumpLoginScreen(tester);

    // Tap "Forgot Password?"
    await tester.tap(find.widgetWithText(TextButton, 'Forgot Password?'));
    await tester.pumpAndSettle(); // Wait for dialog to appear

    // Dialog is visible
    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email Address'), findsOneWidget); // Email field in dialog

    // Enter email in dialog
    await tester.enterText(find.widgetWithText(TextFormField, 'Email Address').last, 'reset@example.com'); // .last because there's one on login screen too
    await tester.pump();

    // Tap "Send Reset Email"
    await tester.tap(find.widgetWithText(FilledButton, 'Send Reset Email')); // Assuming FilledButton in dialog
    await tester.pumpAndSettle(); // Wait for dialog to close and async operations

    // Verify method call
    verify(mockAuthNotifier.sendPasswordResetEmail(email: 'reset@example.com')).called(1);

    // Verify dialog is closed
    expect(find.text('Reset Password'), findsNothing);
  });

  // Note: Testing GoRouter navigation pushes (like to SignUp) requires a more complex setup
  // with a mock GoRouter or by providing a real router with testable routes.
  // For this example, we focus on the direct interactions within LoginScreen.
}
