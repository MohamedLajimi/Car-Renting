import 'package:car_renting/core/app_status_bloc/app_status_bloc.dart';
import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:car_renting/features/auth/cubits/login_cubit/login_cubit.dart';
import 'package:car_renting/features/auth/routes/auth_routes_names.dart';
import 'package:car_renting/features/auth/widgets/auth_footer.dart';
import 'package:car_renting/features/auth/widgets/continue_with_widget.dart';
import 'package:car_renting/features/auth/widgets/social_auth_button.dart';
import 'package:car_renting/features/auth/widgets/login_form.dart';
import 'package:car_renting/features/auth/widgets/auth_header.dart';
import 'package:car_renting/features/car-management/routes/car_management_routes_names.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            current.status == LoginStatus.success ||
            current.status == LoginStatus.error,
        listener: (context, state) {
          if (state.status == LoginStatus.success && state.user != null) {
            context.read<AppStatusBloc>().add(AppUserChanged(state.user!));
            context.goNamed(CarManagementRoutesNames.renterCarList);
          } else if (state.status == LoginStatus.error &&
              state.errorMessage != null) {
            SnackBarUtils.show(
              context,
              message: context.tr(state.errorMessage!),
              type: SnackBarType.error,
            );
          }
          context.read<LoginCubit>().reset();
        },
        child: IgnorePointer(
          ignoring:
              context.watch<LoginCubit>().state.status == LoginStatus.loading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(bottom: 48),
            child: Column(
              spacing: 24,
              children: [
                AuthHeader(
                  title: context.tr('auth.login.title'),
                  subtitle: context.tr('auth.login.subtitle'),
                ),
                const LoginForm(),
                const ContinueWithWidget(),
                SocialAuthButton(
                  text: context.tr('auth.login.connect_with_google'),
                  iconPath: 'assets/images/google_logo.png',
                  onPressed: () => context.read<LoginCubit>().loginWithGoogle(),
                ),

                AuthFooter(
                  firstText: context.tr('auth.login.no_account'),
                  secondText: context.tr('auth.login.register_now'),
                  onTextPressed: () =>
                      context.pushNamed(AuthRoutesNames.createAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
