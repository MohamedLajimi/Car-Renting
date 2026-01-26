import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/features/car-management/blocs/car_form_cubit/car_form_cubit.dart';
import 'package:car_renting/features/car-management/blocs/car_management_bloc/car_management_bloc.dart';
import 'package:car_renting/features/car-management/routes/car_management_routes_names.dart';
import 'package:car_renting/features/car-management/screens/car_detail_screen.dart';
import 'package:car_renting/features/car-management/screens/car_form_screen.dart';
import 'package:car_renting/features/car-management/screens/renter_car_list_screen.dart';
import 'package:car_renting/features/upload/cubit/upload_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CarManagementRoutes {
  static ShellRoute route = ShellRoute(
    builder: (context, state, child) => BlocProvider(
      create: (context) => serviceLocator<CarManagementBloc>(),
      child: child,
    ),
    routes: [
      GoRoute(
        name: CarManagementRoutesNames.renterCarList,
        path: CarManagementRoutesNames.renterCarListPath,
        builder: (context, state) => const RenterCarListScreen(),
        routes: [
          GoRoute(
            name: CarManagementRoutesNames.addCar,
            path: CarManagementRoutesNames.addCarPath,
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => serviceLocator<CarFormCubit>(),
                ),
              ],
              child: const CarFormScreen(),
            ),
          ),
          GoRoute(
            name: CarManagementRoutesNames.carDetail,
            path: CarManagementRoutesNames.carDetailPath,
            builder: (context, state) {
              final carId = state.pathParameters['carId'] as String;
              return CarDetailScreen(carId: carId);
            },
            routes: [
              GoRoute(
                name: CarManagementRoutesNames.updateCar,
                path: CarManagementRoutesNames.updateCarPath,
                builder: (context, state) {
                  final carId = state.pathParameters['carId'] as String;
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => serviceLocator<CarFormCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => serviceLocator<UploadCubit>(),
                      ),
                    ],
                    child: CarFormScreen(carId: carId),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
