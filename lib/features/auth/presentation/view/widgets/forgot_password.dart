import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:flutter/material.dart';

class ForgotPasword extends StatelessWidget {
  const ForgotPasword({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // Handle forgot password action
        },

        child: Text(
          'Forgot Password?',
          style: Styles.textStyle14.copyWith(
            color: AppColors.primaryText.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
