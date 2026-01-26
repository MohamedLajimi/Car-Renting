import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/features/car-management/blocs/car_form_cubit/car_form_cubit.dart';
import 'package:car_renting/features/car-management/blocs/car_management_bloc/car_management_bloc.dart';
import 'package:car_renting/features/car-management/repositories/car_management_repository_imp.dart';
import 'package:car_renting/features/car-management/repositories/i_car_management_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> initCarManagementDependencies() async {
  serviceLocator.registerFactory<ICarManagmentRepository>(
    () => CarManagementRepositoryImp(
      auth: serviceLocator<FirebaseAuth>(),
      firestore: serviceLocator<FirebaseFirestore>(),
    ),
  );

  serviceLocator.registerFactory<CarManagementBloc>(
    () => CarManagementBloc(
      repository: serviceLocator<ICarManagmentRepository>(),
    ),
  );

  serviceLocator.registerFactory<CarFormCubit>(() => CarFormCubit());
}
