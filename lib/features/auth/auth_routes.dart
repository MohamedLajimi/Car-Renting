import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/core/routes/app_routes.dart';
import 'package:car_renting/features/auth/screens/create_account_screen.dart';
import 'package:car_renting/features/auth/screens/forgot_password_screen.dart';
import 'package:car_renting/features/auth/screens/login_screen.dart';
import 'package:car_renting/features/auth/screens/onboarding_screen.dart';
import 'package:car_renting/features/auth/screens/root_loading_screen.dart';
import 'package:car_renting/features/upload/cubit/upload_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      name: AppRoutes.root,
      path: AppRoutes.rootPath,
      builder: (context, state) => const RootLoadingScreen(),
    ),
    GoRoute(
      name: AppRoutes.onboarding,
      path: AppRoutes.onboardingPath,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      name: AppRoutes.login,
      path: AppRoutes.loginPath,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: AppRoutes.createAccount,
      path: AppRoutes.createAccountPath,
      builder: (context, state) => BlocProvider(
        create: (context) => serviceLocator<UploadCubit>(),
        child: const CreateAccountScreen(),
      ),
    ),
    GoRoute(
      name: AppRoutes.forgotPassword,
      path: AppRoutes.forgotPasswordPath,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ];
}
