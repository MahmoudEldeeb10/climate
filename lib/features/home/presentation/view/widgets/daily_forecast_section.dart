import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/features/home/data/models/weather_model.dart';
import 'package:flutter/material.dart';

class DailyForecastSection extends StatelessWidget {
  final List<DailyWeather> daily;

  const DailyForecastSection({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    // Show only 5 days
    final days = daily.take(5).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('5-Day Forecast', style: Styles.textStyle16),
          const SizedBox(height: 15),
          ...days.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Day name — e.g. "Mon"
                  SizedBox(
                    width: 50,
                    child: Text(
                      item.dayName.substring(0, 3),
                      style: Styles.textStyle16,
                    ),
                  ),

                  // Sunrise 🌅
                  Row(
                    children: [
                      const Icon(
                        Icons.wb_twilight,
                        color: Colors.orangeAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(item.sunrise),
                        style: Styles.textStyle14.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  // Sunset 🌇
                  Row(
                    children: [
                      const Icon(
                        Icons.nights_stay,
                        color: Colors.blueAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(item.sunset),
                        style: Styles.textStyle14.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Converts "2025-05-28T05:30" → "5:30 AM"
  String _formatTime(String isoTime) {
    try {
      final dt = DateTime.parse(isoTime);
      final hour = dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final suffix = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      return '$displayHour:$minute $suffix';
    } catch (_) {
      return isoTime;
    }
  }
}
