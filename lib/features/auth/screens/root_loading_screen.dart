import 'package:car_renting/core/routes/app_routes.dart';
import 'package:car_renting/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RootLoadingScreen extends StatefulWidget {
  const RootLoadingScreen({super.key});

  @override
  State<RootLoadingScreen> createState() => _RootLoadingScreenState();
}

class _RootLoadingScreenState extends State<RootLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  void _checkFirstTime() {
    context.read<AuthBloc>().add(AuthCheckOnboardingStatus());
  }

  void _handleListener(BuildContext context, AuthState state) {
    if (state is AuthOnboardingRequired) {
      context.go(AppRoutes.onboardingPath);
    } else {
      context.go(AppRoutes.loginPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleListener,
        child: Center(child: const CircularProgressIndicator()),
      ),
    );
  }
}
