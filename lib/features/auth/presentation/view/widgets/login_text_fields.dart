import 'package:climate/features/auth/presentation/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginTextFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginTextFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
