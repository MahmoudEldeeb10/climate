import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:flutter/material.dart';

class DailyForecastSection extends StatelessWidget {
  const DailyForecastSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dailyData = [
      {'day': 'Mon', 'icon': Icons.cloud, 'temp': '22°'},
      {'day': 'Tue', 'icon': Icons.wb_sunny, 'temp': '25°'},
      {'day': 'Wed', 'icon': Icons.grain, 'temp': '20°'},
      {'day': 'Thu', 'icon': Icons.cloud, 'temp': '23°'},
      {'day': 'Fri', 'icon': Icons.wb_sunny, 'temp': '26°'},
    ];

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

          ...dailyData.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['day'], style: Styles.textStyle16),

                  Icon(item['icon'], color: Colors.white),

                  Text(item['temp'], style: Styles.textStyle16),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
