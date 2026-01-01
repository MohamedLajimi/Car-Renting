import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/features/auth/auth_routes.dart';
import 'package:car_renting/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (context) => serviceLocator<AuthBloc>(),
        child: child,
      ),
      routes: AuthRoutes.routes,
    ),
  ],
);
