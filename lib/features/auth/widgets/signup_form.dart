import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/utils/auth_validators.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/custom_text_form_field.dart';
import 'package:car_renting/core/widgets/custom_segment_control.dart';
import 'package:car_renting/features/auth/cubits/signup_cubit/signup_cubit.dart';
import 'package:car_renting/features/auth/models/signup_params.dart';
import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:car_renting/features/upload/cubit/upload_cubit.dart';
import 'package:car_renting/features/upload/widgets/single_image_uploader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
  }

  void _onCreateAccount(SignupState state) {
    if (_formKey.currentState!.validate()) {
      final params = SignUpParams(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneController.text,
        role: state.role,
        avatarUrl: state.avatarUrl,
        licenceUrl: state.avatarUrl,
      );

      context.read<SignupCubit>().signupWithEmailAndPassword(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final cubit = context.read<SignupCubit>();
        final selectedIndex = state.role == UserRole.renter ? 0 : 1;
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              CustomTextFormField(
                prefixIcon: CupertinoIcons.person,
                hintText: context.tr('auth.register.full_name'),
                controller: _fullNameController,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                prefixIcon: CupertinoIcons.phone,
                inputType: TextInputType.phone,
                hintText: context.tr('auth.register.phone'),
                controller: _phoneController,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                prefixIcon: CupertinoIcons.mail,
                inputType: TextInputType.emailAddress,
                hintText: context.tr('auth.login.email'),
                controller: _emailController,
                validator: (value) => AuthValidators.email(
                  value,
                  context.tr('auth.validation.invalid_email'),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                prefixIcon: CupertinoIcons.lock,
                isObscureText: !state.visiblePassword,
                suffixIcon: state.visiblePassword
                    ? CupertinoIcons.eye_slash
                    : CupertinoIcons.eye,
                onTapSuffixIcon: () =>
                    cubit.updatePasswordVisibility(!state.visiblePassword),
                hintText: context.tr('auth.login.password'),
                controller: _passwordController,
                validator: (value) => AuthValidators.password(
                  value,
                  context.tr('auth.validation.invalid_password'),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tr('auth.validation.password_hint'),
                style: context.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                context.tr('auth.register.role_selection.title'),
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomSegmentedControl(
                selectedIndex: selectedIndex,
                labelOne: context.tr('auth.register.role_selection.renter'),
                labelTwo: context.tr('auth.register.role_selection.owner'),
                onChanged: (value) {
                  if (value != selectedIndex) {
                    cubit.updateRole(
                      value == 0 ? UserRole.renter : UserRole.owner,
                    );
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: BlocProvider(
                      create: (context) => serviceLocator<UploadCubit>(),
                      child: SingleImageUploader(
                        desc: 'Profile Picture',
                        onSuccess: (url) => cubit.updateAvatar(url),
                        onRemove: () => cubit.updateAvatar(null),
                      ),
                    ),
                  ),
                  if (state.role == UserRole.renter)
                    Expanded(
                      child: BlocProvider(
                        create: (context) => serviceLocator<UploadCubit>(),
                        child: SingleImageUploader(
                          desc: 'License Picture',
                          onSuccess: (url) => cubit.updateLicense(url),
                          onRemove: () => cubit.updateLicense(null),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: context.tr('auth.register.register_button'),
                isLoading:
                    state.status == SignupStatus.loading &&
                    _emailController.text.isNotEmpty,
                onPressed: () => _onCreateAccount(state),
              ),
            ],
          ),
        );
      },
    );
  }
}
