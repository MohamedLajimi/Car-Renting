import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/utils/auth_validators.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/custom_text_form_field.dart';
import 'package:car_renting/features/auth/cubits/login_cubit/login_cubit.dart';
import 'package:car_renting/features/auth/routes/auth_routes_names.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _onConnect() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().loginWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          CustomTextFormField(
            inputType: TextInputType.emailAddress,
            prefixIcon: CupertinoIcons.mail,
            hintText: context.tr('auth.login.email'),
            controller: _emailController,
            validator: (value) => AuthValidators.email(
              value,
              context.tr('auth.validation.invalid_email'),
            ),
          ),
          const SizedBox(height: 16),
          BlocSelector<LoginCubit, LoginState, bool>(
            selector: (state) {
              return state.visiblePassword;
            },
            builder: (context, isVisible) {
              return CustomTextFormField(
                prefixIcon: CupertinoIcons.lock,
                suffixIcon: isVisible
                    ? CupertinoIcons.eye_slash
                    : CupertinoIcons.eye,
                onTapSuffixIcon: () => context
                    .read<LoginCubit>()
                    .updatePasswordVisibility(!isVisible),
                isObscureText: !isVisible,
                hintText: context.tr('auth.login.password'),
                controller: _passwordController,
              );
            },
          ),

          Align(
            alignment: AlignmentGeometry.centerRight,
            child: TextButton(
              onPressed: () => context.pushNamed(AuthRoutesNames.forgotPassword),
              child: Text(
                context.tr('auth.login.forgot_password'),
                style: context.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 24),
          BlocSelector<LoginCubit, LoginState, bool>(
            selector: (state) {
              return state.status == LoginStatus.loading &&
                  _emailController.text.isNotEmpty;
            },
            builder: (context, isLoading) {
              return CustomButton(
                isLoading: isLoading,
                text: context.tr('auth.login.login_button'),
                onPressed: _onConnect,
              );
            },
          ),
        ],
      ),
    );
  }
}
