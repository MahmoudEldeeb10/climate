import 'package:climate/appnavigator.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/features/auth/presentation/view/signup_view.dart';
import 'package:flutter/material.dart';

class singup_text extends StatelessWidget {
  const singup_text({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have an account? ', style: Styles.textStyle14),
        GestureDetector(
          onTap: () {
            AppNavigator.goToAndClearStack(context, SignupView());
          },
          child: Text(
            'Sign Up',
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
