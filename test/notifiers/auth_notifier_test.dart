// test/notifiers/auth_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth; // Alias to avoid conflict
import 'package:paw_sync/core/auth/notifiers/auth_notifier.dart';
import 'package:paw_sync/core/auth/providers/auth_providers.dart';
import 'package:paw_sync/core/auth/repositories/auth_repository.dart';

// This annotation will generate mock_auth_repository.mocks.dart
// User must run: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([AuthRepository, fb_auth.User, fb_auth.UserCredential]) // fb_auth.User for return types
import 'auth_notifier_test.mocks.dart'; // Import generated mocks

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser; // Mock Firebase User

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser(); // Mock Firebase User
    // Mock common User properties if needed by the notifier/UI
    when(mockUser.uid).thenReturn('testUid');
    when(mockUser.email).thenReturn('test@example.com');
  });

  // Helper to create a ProviderContainer with overrides
  ProviderContainer createContainer({
    AuthRepository? authRepository,
    Stream<fb_auth.User?>? authStateChangesStream,
  }) {
    final container = ProviderContainer(
      overrides: [
        if (authRepository != null)
          authRepositoryProvider.overrideWithValue(authRepository),
        if (authStateChangesStream != null)
          authStateChangesProvider.overrideWith((ref) => authStateChangesStream)
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthNotifier Tests', () {
    test('Initial state is AsyncLoading, then AsyncData(null) if no user from stream', () async {
      // Arrange
      final container = createContainer(
        authRepository: mockAuthRepository,
        // Simulate authStateChanges emitting null initially
        authStateChangesStream: Stream.value(null),
      );
      final listener = Listener<AsyncValue<fb_auth.User?>>();
      container.listen(authNotifierProvider, listener.call, fireImmediately: true);

      // Assert initial loading state
      expect(listener.log.first, const AsyncLoading<fb_auth.User?>());

      // Wait for the stream to emit and notifier to rebuild
      await container.read(authNotifierProvider.future);

      // Assert final state after stream emission
      expect(listener.log.last, const AsyncData<fb_auth.User?>(null));
      verify(listener(null, const AsyncLoading<fb_auth.User?>())).called(1);
      verify(listener(const AsyncLoading<fb_auth.User?>(), const AsyncData<fb_auth.User?>(null))).called(1);
    });

    test('Initial state is AsyncLoading, then AsyncData(user) if user from stream', () async {
      when(mockAuthRepository.authStateChanges).thenAnswer((_) => Stream.value(mockUser));

      final container = createContainer(
        authRepository: mockAuthRepository,
        authStateChangesStream: Stream.value(mockUser) // Stream emits a mock user
      );
      final listener = Listener<AsyncValue<fb_auth.User?>>();
      container.listen(authNotifierProvider, listener.call, fireImmediately: true);

      expect(listener.log.first, const AsyncLoading<fb_auth.User?>());

      final user = await container.read(authNotifierProvider.future);

      expect(user, mockUser);
      expect(listener.log.last, AsyncData<fb_auth.User?>(mockUser));
    });


    test('signInWithEmailAndPassword success updates state via authStateChanges', () async {
      // Arrange
      // Simulate authStateChanges: first null, then a user after successful login
      final authStreamController = StreamController<fb_auth.User?>();
      when(mockAuthRepository.signInWithEmailAndPassword(email: 'test@example.com', password: 'password'))
          .thenAnswer((_) async {
        // Simulate successful login by pushing user to authStateChanges stream
        authStreamController.add(mockUser);
        return mockUser; // Return mockUser from signIn method
      });

      final container = createContainer(
        authRepository: mockAuthRepository,
        authStateChangesStream: authStreamController.stream,
      );

      // Initially, let's assume no user is logged in.
      authStreamController.add(null);
      await container.read(authNotifierProvider.future); // Wait for initial state

      final listener = Listener<AsyncValue<fb_auth.User?>>();
      container.listen(authNotifierProvider, listener.call, fireImmediately: true);

      // Act
      // Call signInWithEmailAndPassword
      await container.read(authNotifierProvider.notifier).signInWithEmailAndPassword('test@example.com', 'password');

      // Assert
      // 1. Initial state (already null from setup)
      // 2. Loading state during signIn
      // 3. Data state with user (because authStateChanges stream emitted the user)

      // Verify order of states if signIn itself sets loading state
      // The AuthNotifier sets state = AsyncLoading() itself.
      // Then, the build method reacts to the stream.
      expect(listener.log, [
        // Initial data (null)
        // If fireImmediately: true, it will log the current state first.
        // The current state is AsyncData(null) because authStreamController.add(null) was called.
        const AsyncData<fb_auth.User?>(null),
        // Loading state set by signInWithEmailAndPassword
        const AsyncLoading<fb_auth.User?>(),
        // Data state after authStateChanges emits the user
        AsyncData<fb_auth.User?>(mockUser),
      ]);

      // Ensure the repository method was called
      verify(mockAuthRepository.signInWithEmailAndPassword(email: 'test@example.com', password: 'password')).called(1);
      await authStreamController.close();
    });

    test('signInWithEmailAndPassword failure updates state to AsyncError', () async {
      final exception = AuthRepositoryException("Login failed");
      when(mockAuthRepository.signInWithEmailAndPassword(email: 'wrong@example.com', password: 'wrongpassword'))
          .thenThrow(exception);

      final container = createContainer(
          authRepository: mockAuthRepository,
          authStateChangesStream: Stream.value(null) // No user logged in
      );
      await container.read(authNotifierProvider.future); // Ensure initial build completes

      final listener = Listener<AsyncValue<fb_auth.User?>>();
      container.listen(authNotifierProvider, listener.call, fireImmediately: true);

      // Act
      await container.read(authNotifierProvider.notifier).signInWithEmailAndPassword('wrong@example.com', 'wrongpassword');

      // Assert
      expect(listener.log, [
        const AsyncData<fb_auth.User?>(null), // Initial state
        const AsyncLoading<fb_auth.User?>(), // Loading during signIn
        isA<AsyncError<fb_auth.User?>>().having((e) => e.error, 'error', exception), // Error state
      ]);
      verify(mockAuthRepository.signInWithEmailAndPassword(email: 'wrong@example.com', password: 'wrongpassword')).called(1);
    });

    test('signOut success updates state via authStateChanges', () async {
      final authStreamController = StreamController<fb_auth.User?>();
      when(mockAuthRepository.signOut()).thenAnswer((_) async {
        authStreamController.add(null); // Simulate user becoming null after sign out
      });

      final container = createContainer(
        authRepository: mockAuthRepository,
        authStateChangesStream: authStreamController.stream,
      );

      // Start with a logged-in user
      authStreamController.add(mockUser);
      await container.read(authNotifierProvider.future); // Wait for initial logged-in state

      final listener = Listener<AsyncValue<fb_auth.User?>>();
      container.listen(authNotifierProvider, listener.call, fireImmediately: true);

      // Act
      await container.read(authNotifierProvider.notifier).signOut();

      // Assert
      expect(listener.log, [
        AsyncData<fb_auth.User?>(mockUser), // Initial state (user logged in)
        const AsyncLoading<fb_auth.User?>(),      // Loading during signOut
        const AsyncData<fb_auth.User?>(null),       // Final state (user logged out)
      ]);
      verify(mockAuthRepository.signOut()).called(1);
      await authStreamController.close();
    });

     test('signUpWithEmailAndPassword success updates state via authStateChanges', () async {
      final authStreamController = StreamController<fb_auth.User?>();
      when(mockAuthRepository.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'newpassword',
        displayName: 'New User'
      )).thenAnswer((_) async {
        authStreamController.add(mockUser); // Simulate new user being emitted
        return mockUser;
      });

      final container = createContainer(
        authRepository: mockAuthRepository,
        authStateChangesStream: authStreamController.stream,
      );
      authStreamController.add(null); // Start with no user
      await container.read(authNotifierProvider.future);

      final listener = Listener<AsyncValue<fb_auth.User?>>();
      container.listen(authNotifierProvider, listener.call, fireImmediately: true);

      await container.read(authNotifierProvider.notifier).signUpWithEmailAndPassword(
        'new@example.com',
        'newpassword',
        displayName: 'New User'
      );

      expect(listener.log, [
        const AsyncData<fb_auth.User?>(null),
        const AsyncLoading<fb_auth.User?>(),
        AsyncData<fb_auth.User?>(mockUser),
      ]);
      verify(mockAuthRepository.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'newpassword',
        displayName: 'New User'
      )).called(1);
      await authStreamController.close();
    });

  });
}

// Helper listener class to track emissions
class Listener<T> {
  final List<T?> log = [];
  void call(T? previous, T next) {
    log.add(next);
    print('State changed: $next');
  }
}
