import 'dart:ui';
import 'package:climate/constants.dart';
import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'icon_box.dart';

class GlassCard extends StatelessWidget {
  final String icon;
  final String title;
  final String text;

  const GlassCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                IconBox(path: icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Styles.textStyle16),
                      const SizedBox(height: 6),
                      Text(text, style: Styles.textStyle14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
