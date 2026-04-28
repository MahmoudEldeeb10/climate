import 'dart:ui';
import 'package:climate/constants.dart';
import 'package:climate/core/utils/icon_box.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/styles.dart';

class AiTipCard extends StatelessWidget {
  const AiTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
            children: const [
              IconBox(path: "assets/images/tip.png"),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("AI Tip", style: Styles.textStyle16),
                    SizedBox(height: 6),
                    Text(
                      "Temperature drops by evening, bring a jacket!",
                      style: Styles.textStyle14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
