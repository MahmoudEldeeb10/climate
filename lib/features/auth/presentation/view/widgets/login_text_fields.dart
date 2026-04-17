
import 'package:climate/features/auth/presentation/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginTextFields extends StatelessWidget {
   final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginTextFields({super.key, required this.emailController, required this.passwordController});

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(controller: emailController, hint: 'Email'),
        SizedBox(height: 16),
        CustomTextField(
          controller: passwordController,
          hint: 'Password',
          isPassword: true,
        ),
      ],
    );
  }
}
