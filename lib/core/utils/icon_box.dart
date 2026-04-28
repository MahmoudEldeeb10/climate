import 'package:climate/constants.dart';
import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final String path;

  const IconBox({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.cardBackgroundColor,
            AppColors.cardBackgroundColor2,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Image.asset(path, width: 40, height: 40),
    );
  }
}
