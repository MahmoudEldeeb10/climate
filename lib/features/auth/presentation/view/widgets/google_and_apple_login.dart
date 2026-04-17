import 'package:climate/constants.dart';
import 'package:climate/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class google_and_apple_login extends StatelessWidget {
  const google_and_apple_login({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Button
        CustomButton(
          text: 'Google',
          onpressed: () {},
          color: AppColors.cardBackgroundColor,
          textColor: AppColors.primaryText,
          icon: Icon(Icons.g_mobiledata),
        ),
        const SizedBox(height: 18),

        CustomButton(
          text: 'Apple',
          onpressed: () {},
          color: AppColors.cardBackgroundColor,
          textColor: AppColors.primaryText,
          icon: Icon(Icons.apple),
        ),
      ],
    );
  }
}
