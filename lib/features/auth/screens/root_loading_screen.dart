import 'package:car_renting/core/app_status_bloc/app_status_bloc.dart';
import 'package:car_renting/features/auth/routes/auth_routes_names.dart';
import 'package:car_renting/features/car-management/routes/car_management_routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RootLoadingScreen extends StatelessWidget {
  const RootLoadingScreen({super.key});

  void _handleListener(BuildContext context, AppStatusState state) {
    if (state is AppStatusOnboardingRequired) {
      context.goNamed(AuthRoutesNames.onboarding);
    } else if (state is AppStatusAuthenticated) {
      context.goNamed(CarManagementRoutesNames.renterCarList);
    } else if (state is AppStatusUnauthenticated) {
      context.goNamed(AuthRoutesNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppStatusBloc, AppStatusState>(
        listener: _handleListener,
        child: Center(child: const CircularProgressIndicator()),
      ),
    );
  }
}
