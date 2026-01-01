import 'package:car_renting/features/auth/init_auth_dependencies.dart';
import 'package:car_renting/features/upload/init_upload_dependencies.dart';
import 'package:car_renting/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await EasyLocalization.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton(() => sharedPrefs);

  await initAuthDependencies();

  await initUploadDependencies();
}
