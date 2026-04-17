import 'package:climate/constants.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  const CustomIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryText, width: 0.5),
        shape: BoxShape.circle,
        color: AppColors.cardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Icon(icon, size: 65, color: AppColors.primaryText),
      ),
    );
  }
}