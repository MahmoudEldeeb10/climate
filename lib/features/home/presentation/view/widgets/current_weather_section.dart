import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/features/home/data/models/weather_model.dart';
import 'package:flutter/material.dart';

class CurrentWeatherSection extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final current = weather.hourly.first;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Egypt",
            style: TextStyle(
              color: AppColors.primaryText.withOpacity(0.7),
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${current.temperature.round()}°',
            style: Styles.textStyle30.copyWith(fontSize: 70),
          ),
          Text(
            current.uvLabel,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.primaryText.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
