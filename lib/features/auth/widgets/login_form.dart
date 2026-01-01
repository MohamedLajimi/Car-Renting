import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/routes/app_routes.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/custom_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomField(
            hintText: context.tr('auth.login.email'),
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          CustomField(
            hintText: context.tr('auth.login.password'),
            controller: _passwordController,
          ),

          Align(
            alignment: AlignmentGeometry.centerRight,
            child: TextButton(
              onPressed: () => context.push(AppRoutes.forgotPasswordPath),
              child: Text(
                context.tr('auth.login.forgot_password'),
                style: context.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: context.tr('auth.login.login_button'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
