import 'package:car_renting/env_config.dart';
import 'package:car_renting/features/auth/init_auth_dependencies.dart';
import 'package:car_renting/features/upload/init_upload_dependencies.dart';
import 'package:car_renting/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await GoogleSignIn.instance.initialize(
    serverClientId: EnvConfig.serverClientId,
  );

  await EasyLocalization.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton(() => sharedPrefs);



  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  await initAuthDependencies();

  await initUploadDependencies();
}
