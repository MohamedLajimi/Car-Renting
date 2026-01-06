import 'package:car_renting/core/app_status_bloc/app_status_bloc.dart';
import 'package:car_renting/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RootLoadingScreen extends StatelessWidget {
  const RootLoadingScreen({super.key});

  void _handleListener(BuildContext context, AppStatusState state) {
    if (state is AppStatusOnboardingRequired) {
      context.go(AppRoutes.onboardingPath);
    } else if (state is AppStatusAuthenticated) {
      context.go(AppRoutes.homePath);
    } else if (state is AppStatusUnauthenticated) {
      context.go(AppRoutes.loginPath);
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
