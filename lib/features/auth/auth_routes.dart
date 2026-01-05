import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/core/routes/app_routes.dart';
import 'package:car_renting/features/auth/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:car_renting/features/auth/cubits/login_cubit/login_cubit.dart';
import 'package:car_renting/features/auth/cubits/signup_cubit/signup_cubit.dart';
import 'package:car_renting/features/auth/screens/signup_screen.dart';
import 'package:car_renting/features/auth/screens/forgot_password_screen.dart';
import 'package:car_renting/features/auth/screens/login_screen.dart';
import 'package:car_renting/features/auth/widgets/onboarding_screen.dart';
import 'package:car_renting/features/auth/screens/root_loading_screen.dart';
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
      builder: (context, state) => BlocProvider(
        create: (context) => serviceLocator<LoginCubit>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      name: AppRoutes.createAccount,
      path: AppRoutes.createAccountPath,
      builder: (context, state) => BlocProvider(
        create: (context) => serviceLocator<SignupCubit>(),
        child: const SignupScreen(),
      ),
    ),
    GoRoute(
      name: AppRoutes.forgotPassword,
      path: AppRoutes.forgotPasswordPath,
      builder: (context, state) => BlocProvider(
        create: (context) => serviceLocator<ForgotPasswordCubit>(),
        child: const ForgotPasswordScreen(),
      ),
    ),
  ];
}
