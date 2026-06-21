import 'package:climate/features/auth/presentation/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignupTextFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  const SignupTextFields({
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
        CustomTextField(
          controller: fullNameController,
          hint: 'Full Name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: emailController,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            if (!value.contains('@')) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: passwordController,
          hint: 'Password',
          isPassword: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: confirmPasswordController,
          hint: 'Confirm Password',
          isPassword: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please confirm your password';
            }
            if (value != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }
}
