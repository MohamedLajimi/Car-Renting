import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/routes/app_routes.dart';
import 'package:car_renting/features/auth/widgets/auth_footer.dart';
import 'package:car_renting/features/auth/widgets/social_auth_button.dart';
import 'package:car_renting/features/auth/widgets/login_form.dart';
import 'package:car_renting/features/auth/widgets/auth_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const .all(16),
        child: Column(
          spacing: 24,
          children: [
            AuthHeader(
              title: context.tr('auth.login.title'),
              subtitle: context.tr('auth.login.subtitle'),
            ),
            LoginForm(),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: colorScheme.onSurfaceVariant.withAlpha(100),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.tr('auth.login.continue_with'),
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: colorScheme.onSurfaceVariant.withAlpha(100),
                  ),
                ),
              ],
            ),

            SocialAuthButton(
              text: context.tr('auth.login.connect_with_google'),
              iconPath: 'assets/images/google_logo.png',
              onPressed: () {},
            ),

            AuthFooter(
              firstText: context.tr('auth.login.no_account'),
              secondText: context.tr('auth.login.register_now'),
              onTextPressed: () => context.push(AppRoutes.createAccountPath),
            ),
          ],
        ),
      ),
    );
  }
}
