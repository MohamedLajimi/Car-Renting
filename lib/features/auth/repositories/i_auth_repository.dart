import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/features/auth/models/signup_params.dart';
import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class IAuthRepository {
  bool isFirstTime();

  Future<void> makeOnboardingComplete();

  Future<Either<Failure, UserModel>> getCurrentUserData();

  Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> signupWithEmailAndPassword({
    required SignUpParams params,
  });

  Future<Either<Failure, UserModel>> loginWithGoogle();

  Future<Either<Failure, UserModel>> signupWithGoogle();

  Future<Either<Failure, Unit>> forgotPassword({required String email});

  Future<Either<Failure, Unit>> logout();
}
