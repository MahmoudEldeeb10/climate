import 'dart:ui';

import 'package:climate/constants.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/styles.dart';

class WeeklyOutlookCard extends StatelessWidget {
  const WeeklyOutlookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weekly Outlook",
          style: Styles.textStyle22.copyWith(fontWeight: FontWeight.bold),
        ),
        // const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(12.0),
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
                child: Column(
                  children: [
                    _row("assets/images/rainy.png", "Rain likely on Wednesday"),
                    _row("assets/images/sun.png", "Sunny weekend ahead"),
                    _row("assets/images/wind.png", "Light winds all week"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Image.asset(icon, width: 20),
          const SizedBox(width: 10),
          Text(text, style: Styles.textStyle14),
        ],
      ),
    );
  }
}
