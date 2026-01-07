import 'package:car_renting/features/auth/routes/auth_routes.dart';
import 'package:car_renting/features/car-management/routes/car_management_routes.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  routes: [...AuthRoutes.routes, CarManagementRoutes.route],
);
