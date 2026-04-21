import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:flutter/material.dart';

class WeatherDetailsSection extends StatelessWidget {
  const WeatherDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Feels like
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Feels like",
                style: Styles.textStyle16.copyWith(
                  color: AppColors.primaryText.withOpacity(0.6),
                ),
              ),
              Text("30°", style: Styles.textStyle16),
            ],
          ),

          const Divider(color: Colors.white24, height: 20),

          // Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _DetailItem(title: "Humidity", value: "60%"),
              _DetailItem(title: "Wind", value: "12 km/h"),
              _DetailItem(title: "Pressure", value: "1012 hPa"),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const _DetailItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Styles.textStyle14.copyWith(
            color: AppColors.primaryText.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 5),
        Text(value, style: Styles.textStyle16),
      ],
    );
  }
}
