import 'package:car_renting/core/app_status_bloc/app_status_bloc.dart';
import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:car_renting/features/auth/cubits/signup_cubit/signup_cubit.dart';
import 'package:car_renting/features/auth/widgets/auth_footer.dart';
import 'package:car_renting/features/auth/widgets/auth_header.dart';
import 'package:car_renting/features/auth/widgets/continue_with_widget.dart';
import 'package:car_renting/features/auth/widgets/signup_form.dart';
import 'package:car_renting/features/auth/widgets/social_auth_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<SignupCubit, SignupState>(
        listenWhen: (previous, current) =>
            current.status == SignupStatus.success ||
            current.status == SignupStatus.error,
        listener: (context, state) {
          if (state.status == SignupStatus.success && state.user != null) {
            SnackBarUtils.show(
              context,
              message: context.tr('auth.register.signup_success'),
              type: SnackBarType.success,
            );
            context.read<AppStatusBloc>().add(AppUserChanged(state.user!));
          } else if (state.status == SignupStatus.error &&
              state.errorMessage != null) {
            SnackBarUtils.show(
              context,
              message: context.tr(state.errorMessage!),
              type: SnackBarType.error,
            );
          }
          context.read<SignupCubit>().reset();
        },
        child: IgnorePointer(
          ignoring:
              context.watch<SignupCubit>().state.status == SignupStatus.loading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(bottom: 48),
            child: Column(
              spacing: 24,
              children: [
                AuthHeader(
                  title: context.tr('auth.register.title'),
                  subtitle: context.tr('auth.register.subtitle'),
                ),
                const SignupForm(),
                const ContinueWithWidget(),
                SocialAuthButton(
                  text: context.tr('auth.register.connect_with_google'),
                  iconPath: 'assets/images/google_logo.png',
                  onPressed: () =>
                      context.read<SignupCubit>().signupWithGoogle(),
                ),
                AuthFooter(
                  firstText: context.tr('auth.register.have_account'),
                  secondText: context.tr('auth.register.login_now'),
                  onTextPressed: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
