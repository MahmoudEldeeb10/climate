import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/core/widgets/custom_button.dart';
import 'package:climate/core/widgets/custom_icon.dart';
import 'package:climate/features/auth/presentation/view/widgets/custom_divider.dart';
import 'package:climate/features/auth/presentation/view/widgets/forgot_password.dart';
import 'package:climate/features/auth/presentation/view/widgets/google_and_apple_login.dart';
import 'package:climate/features/auth/presentation/view/widgets/login_text_fields.dart';
import 'package:climate/features/auth/presentation/view/widgets/signup_text.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 42,
            bottom: 22,
          ),
          child: Column(
            children: [
              CustomIcon(icon: Icons.cloud),
              SizedBox(height: 24),
              Text('Welcome Back', style: Styles.textStyle30),
              Text('Sign in to continue', style: Styles.textStyle14),
              SizedBox(height: 24),

              LoginTextFields(
                emailController: emailController,
                passwordController: passwordController,
              ),
              SizedBox(height: 16),
              ForgotPasword(),
              SizedBox(height: 16),

              CustomButton(
                text: 'Sign In',
                onpressed: () {},
                color: AppColors.primaryText,
                textColor: AppColors.tertiaryText,
              ),
              SizedBox(height: 16),
              custom_divider(),
              SizedBox(height: 16),
              google_and_apple_login(),
              Spacer(),
              singup_text(),
            ],
          ),
        ),
      ),
    );
  }
}
