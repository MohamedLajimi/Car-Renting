import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/features/upload/cubit/upload_cubit.dart';
import 'package:car_renting/features/upload/repositories/cloudinary_repository.dart';
import 'package:car_renting/core/services/upload_service.dart';
import 'package:dio/dio.dart';

Future<void> initUploadDependencies() async {
  serviceLocator.registerLazySingleton<CloudinaryRepository>(
    () => CloudinaryRepository(Dio()),
  );

  serviceLocator.registerFactory<UploadService>(() => UploadService());

  serviceLocator.registerFactory<UploadCubit>(
    () => UploadCubit(repository: serviceLocator<CloudinaryRepository>()),
  );
}
