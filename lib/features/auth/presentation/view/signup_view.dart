import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/core/widgets/custom_button.dart';
import 'package:climate/core/widgets/custom_icon.dart';
import 'package:climate/features/auth/presentation/view/widgets/custom_divider.dart';
import 'package:climate/features/auth/presentation/view/widgets/google_and_apple_login.dart';
import 'package:climate/features/auth/presentation/view/widgets/login_text.dart';
import 'package:climate/features/auth/presentation/view/widgets/signup_text_fields.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
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
                SizedBox(height: 24),
                Text('Create Account', style: Styles.textStyle30),
                Text('Join ClimateAi today', style: Styles.textStyle14),
                SizedBox(height: 24),
                // SignupTextFields(),
                SignupTextFields(
                  fullNameController: fullNameController,
                  emailController: emailController,
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
                ),
                //sign-up button
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'By signing up, you agree to our Terms of Service and Privacy Policy.',
                    style: Styles.textStyle14,
                  ),
                ),
                SizedBox(height: 16),
                CustomButton(
                  text: 'Sign Up',
                  onpressed: () {},
                  color: AppColors.primaryText,
                  textColor: AppColors.tertiaryText,
                ),
                //divider
                SizedBox(height: 16),
                custom_divider(),
                SizedBox(height: 16),
                google_and_apple_login(),
                SizedBox(height: 32),

                LoginText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
