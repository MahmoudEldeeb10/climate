import 'package:climate/appnavigator.dart';
import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/core/widgets/custom_button.dart';
import 'package:climate/features/auth/data/services/auth_service.dart';
import 'package:climate/features/auth/presentation/manager/auth_cubit.dart';
import 'package:climate/features/auth/presentation/manager/auth_state.dart';
import 'package:climate/features/auth/presentation/view/widgets/custom_divider.dart';
import 'package:climate/features/auth/presentation/view/widgets/forgot_password.dart';
import 'package:climate/features/auth/presentation/view/widgets/google_and_apple_login.dart';
import 'package:climate/features/auth/presentation/view/widgets/login_text_fields.dart';
import 'package:climate/features/auth/presentation/view/widgets/signup_text.dart';
import 'package:climate/features/botton_nav_bar/presentation/views/main_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                AppNavigator.goToAndClearStack(context, MainView());
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
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
                      Text('Welcome Back', style: Styles.textStyle30),
                      Text('Sign in to continue', style: Styles.textStyle14),
                      const SizedBox(height: 24),

                      LoginTextFields(
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                      const SizedBox(height: 16),
                      ForgotPasword(),
                      const SizedBox(height: 16),

                      IgnorePointer(
                        ignoring: isLoading,
                        child: Opacity(
                          opacity: isLoading ? 0.6 : 1,
                          child: CustomButton(
                            text: 'Sign In',
                            onpressed: () {
                              final email = emailController.text.trim();
                              final password =
                                  passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'من فضلك دخلي الإيميل والباسورد'),
                                  ),
                                );
                                return;
                              }

                              context.read<AuthCubit>().login(
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

                      singup_text(),
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