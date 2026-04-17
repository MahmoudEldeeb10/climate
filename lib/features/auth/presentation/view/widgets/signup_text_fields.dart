import 'package:climate/features/auth/presentation/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignupTextFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  SignupTextFields({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(controller: fullNameController, hint: 'Full Name'),
        SizedBox(height: 16),

        CustomTextField(controller: emailController, hint: 'Email'),
        SizedBox(height: 16),
        CustomTextField(
          controller: passwordController,
          hint: 'Password',
          isPassword: true,
        ),
        SizedBox(height: 16),

        CustomTextField(
          controller: confirmPasswordController,
          hint: 'Confirm Password',
          isPassword: true,
        ),
      ],
    );
  }
}
