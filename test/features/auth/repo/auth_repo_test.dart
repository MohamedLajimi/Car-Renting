import 'package:car_renting/features/auth/models/signup_params.dart';
import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:car_renting/features/auth/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../mocks/auth_mocks.dart';


void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late MockSharedPreferences mockSharedPreferences;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    mockSharedPreferences = MockSharedPreferences();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    authRepository = AuthRepository(
      firebaseAuth: mockFirebaseAuth,
      firestore: fakeFirestore,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('isFirstTime', () {
    test('should return true when onboarding key is not set', () {
      when(() => mockSharedPreferences.getBool(AuthRepository.onboardingKey))
          .thenReturn(null);

      final result = authRepository.isFirstTime();

      expect(result, true);
      verify(() => mockSharedPreferences.getBool(AuthRepository.onboardingKey)).called(1);
    });

    test('should return false when onboarding is complete', () {
      when(() => mockSharedPreferences.getBool(AuthRepository.onboardingKey))
          .thenReturn(false);

      final result = authRepository.isFirstTime();

      expect(result, false);
      verify(() => mockSharedPreferences.getBool(AuthRepository.onboardingKey)).called(1);
    });

    test('should return true when onboarding key is true', () {
      when(() => mockSharedPreferences.getBool(AuthRepository.onboardingKey))
          .thenReturn(true);

      final result = authRepository.isFirstTime();

      expect(result, true);
    });
  });

  group('makeOnboardingComplete', () {
    test('should set onboarding key to false', () async {
      when(() => mockSharedPreferences.setBool(AuthRepository.onboardingKey, false))
          .thenAnswer((_) async => true);

      await authRepository.makeOnboardingComplete();

      verify(() => mockSharedPreferences.setBool(AuthRepository.onboardingKey, false)).called(1);
    });
  });

  group('getCurrentUserData', () {
    const userId = 'test-user-id';
    final userData = {
      'email': 'test@example.com',
      'fullName': 'Test User',
      'phoneNumber': '1234567890',
      'role': 'renter',
    };

    test('should return UserModel when user is authenticated and exists in Firestore', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userId);
      
      await fakeFirestore.collection('users').doc(userId).set(userData);

      final result = await authRepository.getCurrentUserData();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.id, userId);
          expect(user.email, userData['email']);
          expect(user.fullName, userData['fullName']);
        },
      );
      verify(() => mockFirebaseAuth.currentUser).called(1);
    });

    test('should return Failure when user is not authenticated', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await authRepository.getCurrentUserData();

      expect(result.isLeft(), isTrue);
      verify(() => mockFirebaseAuth.currentUser).called(1);
    });

    test('should return Failure when user document does not exist', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userId);

      final result = await authRepository.getCurrentUserData();

      expect(result.isLeft(), isTrue);
    });
  });

  group('loginWithEmailAndPassword', () {
    const email = 'test@example.com';
    const password = 'password123';
    const userId = 'test-user-id';
    final userData = {
      'email': email,
      'fullName': 'Test User',
      'phoneNumber': '1234567890',
      'role': 'renter',
    };

    test('should return UserModel on successful login', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userId);
      
      await fakeFirestore.collection('users').doc(userId).set(userData);

      final result = await authRepository.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.id, userId);
          expect(user.email, email);
        },
      );
    });

    test('should return Failure when credentials are invalid', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      final result = await authRepository.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('signupWithEmailAndPassword', () {
    final signUpParams = SignUpParams(
      email: 'test@example.com',
      password: 'password123',
      fullName: 'Test User',
      phoneNumber: '1234567890',
      role: UserRole.renter,
    );
    const userId = 'test-user-id';

    test('should create user and return UserModel on successful signup', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: signUpParams.email,
            password: signUpParams.password,
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userId);

      final result = await authRepository.signupWithEmailAndPassword(
        params: signUpParams,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.id, userId);
          expect(user.email, signUpParams.email);
          expect(user.fullName, signUpParams.fullName);
        },
      );
      
      final doc = await fakeFirestore.collection('users').doc(userId).get();
      expect(doc.exists, isTrue);
    });

    test('should return Failure when email already exists', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: signUpParams.email,
            password: signUpParams.password,
          )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      final result = await authRepository.signupWithEmailAndPassword(
        params: signUpParams,
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('forgotPassword', () {
    const email = 'test@example.com';

    test('should send password reset email successfully', () async {
      when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenAnswer((_) async => {});

      final result = await authRepository.forgotPassword(email: email);

      expect(result.isRight(), true);
      verify(() => mockFirebaseAuth.sendPasswordResetEmail(email: email)).called(1);
    });

    test('should return Failure when email is invalid', () async {
      when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      final result = await authRepository.forgotPassword(email: email);

      expect(result.isLeft(), true);
    });
  });

  group('logout', () {
    test('should sign out user successfully', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      final result = await authRepository.logout();

      expect(result.isRight(), true);
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('should return Failure when sign out fails', () async {
      when(() => mockFirebaseAuth.signOut()).thenThrow(Exception('Sign out failed'));

      final result = await authRepository.logout();

      expect(result.isLeft(), true);
    });
  });

}