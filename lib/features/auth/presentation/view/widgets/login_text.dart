import 'package:climate/appnavigator.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/features/auth/presentation/view/login_view.dart';
import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  const LoginText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? ', style: Styles.textStyle14),
        GestureDetector(
          onTap: () {
            AppNavigator.goToAndClearStack(context, LoginView());
          },
          child: Text(
            'Sign In',
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
