import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/features/auth/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetLinkSuccessView extends StatelessWidget {
  final String email;
  const ResetLinkSuccessView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mark_email_read_outlined, size: 80),
          const SizedBox(height: 24),
          Text(
            context.tr('auth.forgot_password.success_title'),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            context.tr(
              'auth.forgot_password.success_message',
              namedArgs: {'email': email},
            ),
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(context.tr('auth.forgot_password.resend_label')),
          BlocSelector<ForgotPasswordCubit, ForgotPasswordState, (int, bool)>(
            selector: (state) {
              return (state.resendCountdown, state.isResending);
            },
            builder: (context, data) {
              final count = data.$1;
              final isResending = data.$2;
              final canResend = count == 0 && !isResending;

              return TextButton(
                onPressed: canResend
                    ? () => context.read<ForgotPasswordCubit>().sendResetLink(
                        email,
                      )
                    : null,
                child: isResending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        canResend
                            ? context.tr('auth.forgot_password.resend_button')
                            : context.tr(
                                'auth.forgot_password.resend_wait',
                                namedArgs: {'seconds': count.toString()},
                              ),
                        style: TextStyle(
                          color: canResend
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: context.tr('auth.forgot_password.back_to_login'),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
