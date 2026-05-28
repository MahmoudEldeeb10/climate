import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/features/home/data/models/weather_model.dart';
import 'package:flutter/material.dart';

class HourlyForecastSection extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const HourlyForecastSection({super.key, required this.hourly});

  IconData _weatherIcon(double temp) {
    if (temp >= 35) return Icons.wb_sunny;
    if (temp >= 25) return Icons.cloud;
    return Icons.grain;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: hourly.length,
          itemBuilder: (context, index) {
            final item = hourly[index];

            return Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.primaryText.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.formattedTime, style: Styles.textStyle14),
                  Icon(
                    _weatherIcon(item.temperature),
                    color: AppColors.primaryText,
                    size: 26,
                  ),
                  Text(
                    '${item.temperature.round()}°',
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
