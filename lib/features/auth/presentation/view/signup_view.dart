import 'package:climate/appnavigator.dart';
import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/core/widgets/custom_button.dart';
import 'package:climate/features/auth/data/services/auth_service.dart';
import 'package:climate/features/auth/presentation/manager/auth_cubit.dart';
import 'package:climate/features/auth/presentation/manager/auth_state.dart';
import 'package:climate/features/auth/presentation/view/login_view.dart';
import 'package:climate/features/auth/presentation/view/widgets/custom_divider.dart';
import 'package:climate/features/auth/presentation/view/widgets/google_and_apple_login.dart';
import 'package:climate/features/auth/presentation/view/widgets/login_text.dart';
import 'package:climate/features/auth/presentation/view/widgets/signup_text_fields.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthService(Dio())),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Account created successfully, please login now',
                    ),
                  ),
                );
                AppNavigator.goToAndClearStack(context, const LoginView());
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 42,
                  bottom: 22,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/appLogo2.png',
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      const SizedBox(height: 24),
                      Text('Create Account', style: Styles.textStyle30),
                      Text('Join ClimateAi today', style: Styles.textStyle14),
                      const SizedBox(height: 24),
                      SignupTextFields(
                        fullNameController: fullNameController,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'By signing up, you agree to our Terms of Service and Privacy Policy.',
                          style: Styles.textStyle14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      IgnorePointer(
                        ignoring: isLoading,
                        child: Opacity(
                          opacity: isLoading ? 0.6 : 1,
                          child: CustomButton(
                            text: 'Sign Up',
                            onpressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final confirmPassword = confirmPasswordController
                                  .text
                                  .trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'please fill in all required fields',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (password != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Passwords do not match'),
                                  ),
                                );
                                return;
                              }

                              context.read<AuthCubit>().register(
                                email: email,
                                password: password,
                              );
                            },
                            color: AppColors.primaryText,
                            textColor: AppColors.tertiaryText,
                          ),
                        ),
                      ),
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: CircularProgressIndicator(),
                        ),

                      const SizedBox(height: 16),
                      custom_divider(),
                      const SizedBox(height: 16),
                      google_and_apple_login(),
                      const SizedBox(height: 32),

                      LoginText(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
