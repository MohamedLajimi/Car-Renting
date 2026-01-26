import 'package:car_renting/core/app_status_bloc/app_status_bloc.dart';
import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/features/auth/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:car_renting/features/auth/cubits/login_cubit/login_cubit.dart';
import 'package:car_renting/features/auth/cubits/signup_cubit/signup_cubit.dart';
import 'package:car_renting/features/auth/repositories/auth_repository.dart';
import 'package:car_renting/features/auth/repositories/i_auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initAuthDependencies() async {
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);

  serviceLocator.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(
      firebaseAuth: serviceLocator<FirebaseAuth>(),
      firestore: serviceLocator<FirebaseFirestore>(),
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );

  serviceLocator.registerSingleton<AppStatusBloc>(
    AppStatusBloc(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory<SignupCubit>(
    () => SignupCubit(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory<LoginCubit>(
    () => LoginCubit(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory<ForgotPasswordCubit>(
    () =>
        ForgotPasswordCubit(authRepository: serviceLocator<IAuthRepository>()),
  );
}
