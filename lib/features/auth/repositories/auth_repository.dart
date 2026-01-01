import 'package:car_renting/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final SharedPreferences _sharedPreferences;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required SharedPreferences sharedPreferences,
  }) : _firebaseAuth = firebaseAuth,
       _sharedPreferences = sharedPreferences;

  static const onboardingKey = 'is_first_time';

  bool isFirstTime() {
    return _sharedPreferences.getBool(onboardingKey) ?? true;
  }

  Future<void> makeOnboardingComplete() async {
    _sharedPreferences.setBool(onboardingKey, false);
  }
}
