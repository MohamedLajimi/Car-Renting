import 'package:car_renting/core/error/auth_exception_handler.dart';
import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/core/error/safe_call.dart';
import 'package:car_renting/features/auth/models/signup_params.dart';
import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:car_renting/features/auth/repositories/i_auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPreferences;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required SharedPreferences sharedPreferences,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _sharedPreferences = sharedPreferences;

  static const onboardingKey = 'is_first_time';

  @override
  bool isFirstTime() => _sharedPreferences.getBool(onboardingKey) ?? true;

  @override
  Future<void> makeOnboardingComplete() async {
    _sharedPreferences.setBool(onboardingKey, false);
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUserData() async {
    return SafeCall.execute(
      onException: AuthExceptionHandler.handleException,
      action: () async {
        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser == null) throw Exception('auth.error.no_session');

        final userDoc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) throw Exception('auth.error.user_not_found');

        return UserModel.fromMap(userDoc.data()!, firebaseUser.uid);
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return SafeCall.execute(
      onException: AuthExceptionHandler.handleException,
      action: () async {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final firebaseUser = userCredential.user;
        if (firebaseUser == null) throw Exception('auth.error.unknown');

        final userDoc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) throw Exception('auth.error.user_not_found');

        return UserModel.fromMap(userDoc.data()!, firebaseUser.uid);
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> loginWithGoogle() async {
    return signupWithGoogle();
  }

  @override
  Future<Either<Failure, UserModel>> signupWithEmailAndPassword({
    required SignUpParams params,
  }) async {
    return SafeCall.execute(
      onException: AuthExceptionHandler.handleException,
      action: () async {
        final userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(
              email: params.email,
              password: params.password,
            );

        final user = userCredential.user;
        if (user == null) throw Exception('auth.error.unknown');

        final userModel = UserModel(
          id: user.uid,
          email: params.email,
          fullName: params.fullName,
          phoneNumber: params.phoneNumber,
          role: params.role,
          avatarUrl: params.avatarUrl,
          licenceUrl: params.licenceUrl,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        return userModel;
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> signupWithGoogle() async {
    return SafeCall.execute(
      onException: AuthExceptionHandler.handleException,
      action: () async {
        final GoogleSignInAccount googleUser = await GoogleSignIn.instance
            .authenticate();

        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user == null) throw Exception('auth.error.unknown');

        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          final newUser = UserModel(
            id: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'New User',
            phoneNumber: '',
            role: UserRole.renter,
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toMap());
          return newUser;
        }

        return UserModel.fromMap(userDoc.data()!, user.uid);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    return SafeCall.execute(
      onException: AuthExceptionHandler.handleException,
      action: () async {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
        return unit;
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return SafeCall.execute(
      onException: AuthExceptionHandler.handleException,
      action: () async {
        await Future.wait([_firebaseAuth.signOut()]);
        return unit;
      },
    );
  }
}
