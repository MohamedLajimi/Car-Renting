import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/features/auth/bloc/auth_bloc.dart';
import 'package:car_renting/features/auth/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initAuthDependencies() async {
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      firebaseAuth: serviceLocator<FirebaseAuth>(),
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );

  serviceLocator.registerFactory(
    () => AuthBloc(authRepository: serviceLocator<AuthRepository>()),
  );
}
