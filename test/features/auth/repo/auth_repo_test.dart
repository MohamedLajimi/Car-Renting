import 'package:car_renting/features/auth/models/signup_params.dart';
import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:car_renting/features/auth/repositories/auth_repository.dart';
import 'package:car_renting/features/auth/repositories/i_auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockSharedPreferences mockSharedPreferences;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockCollectionReference mockCollectionRef;
  late MockDocumentReference mockDocumentRef;
  late MockDocumentSnapshot mockDocumentSnapshot;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockSharedPreferences = MockSharedPreferences();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockCollectionRef = MockCollectionReference();
    mockDocumentRef = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();

    authRepository = AuthRepository(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
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
      when(() => mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(userId)).thenReturn(mockDocumentRef);
      when(() => mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(() => mockDocumentSnapshot.exists).thenReturn(true);
      when(() => mockDocumentSnapshot.data()).thenReturn(userData);

      final result = await authRepository.getCurrentUserData();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.id, userId);
          expect(user.email, userData['email']);
          expect(user.fullName, userData['fullName']);
        },
      );
      verify(() => mockFirebaseAuth.currentUser).called(1);
      verify(() => mockFirestore.collection('users')).called(1);
    });

    test('should return Failure when user is not authenticated', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await authRepository.getCurrentUserData();

      expect(result.isLeft(), true);
      verify(() => mockFirebaseAuth.currentUser).called(1);
    });

    test('should return Failure when user document does not exist', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userId);
      when(() => mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(userId)).thenReturn(mockDocumentRef);
      when(() => mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(() => mockDocumentSnapshot.exists).thenReturn(false);

      final result = await authRepository.getCurrentUserData();

      expect(result.isLeft(), true);
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
      when(() => mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(userId)).thenReturn(mockDocumentRef);
      when(() => mockDocumentRef.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(() => mockDocumentSnapshot.exists).thenReturn(true);
      when(() => mockDocumentSnapshot.data()).thenReturn(userData);

      final result = await authRepository.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isRight(), true);
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

      expect(result.isLeft(), true);
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
      when(() => mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(userId)).thenReturn(mockDocumentRef);
      when(() => mockDocumentRef.set(any())).thenAnswer((_) async => {});

      final result = await authRepository.signupWithEmailAndPassword(
        params: signUpParams,
      );

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.id, userId);
          expect(user.email, signUpParams.email);
          expect(user.fullName, signUpParams.fullName);
        },
      );
      verify(() => mockDocumentRef.set(any())).called(1);
    });

    test('should return Failure when email already exists', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: signUpParams.email,
            password: signUpParams.password,
          )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      final result = await authRepository.signupWithEmailAndPassword(
        params: signUpParams,
      );

      expect(result.isLeft(), true);
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