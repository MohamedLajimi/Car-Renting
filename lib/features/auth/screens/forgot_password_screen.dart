import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/custom_text_form_field.dart';
import 'package:car_renting/features/auth/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:car_renting/features/auth/screens/reset_link_success_view.dart';
import 'package:car_renting/features/auth/widgets/auth_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _onSendResetLink() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().sendResetLink(_emailController.text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.error) {
            SnackBarUtils.show(
              context,
              message: context.tr(state.errorMessage!),
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            return ResetLinkSuccessView(email: _emailController.text);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(bottom: 48),
            child: Form(
              key: _formKey,
              autovalidateMode: .onUnfocus,
              child: Column(
                spacing: 24,
                crossAxisAlignment: .start,
                children: [
                  AuthHeader(
                    title: context.tr('auth.forgot_password.title'),
                    subtitle: context.tr('auth.forgot_password.subtitle'),
                  ),
                  CustomTextFormField(
                    hintText: context.tr('auth.forgot_password.email_label'),
                    controller: _emailController,
                  ),
                  CustomButton(
                    text: context.tr('auth.forgot_password.send_button'),
                    isLoading: state.status == ForgotPasswordStatus.loading,
                    onPressed: _onSendResetLink,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
