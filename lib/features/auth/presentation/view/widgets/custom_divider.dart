import 'package:climate/constants.dart';
import 'package:flutter/material.dart';

class custom_divider extends StatelessWidget {
  const custom_divider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.primaryText.withOpacity(0.7),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'OR',
              style: TextStyle(color: AppColors.primaryText.withOpacity(0.7)),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.primaryText.withOpacity(0.7),
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
