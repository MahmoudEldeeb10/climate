import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:flutter/material.dart';

class HourlyForecastSection extends StatelessWidget {
  const HourlyForecastSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hourlyData = [
      {'time': 'Now', 'icon': Icons.cloud, 'temp': '72°'},
      {'time': '1 PM', 'icon': Icons.wb_sunny, 'temp': '74°'},
      {'time': '2 PM', 'icon': Icons.cloud, 'temp': '73°'},
      {'time': '3 PM', 'icon': Icons.grain, 'temp': '70°'},
      {'time': '4 PM', 'icon': Icons.cloud, 'temp': '69°'},
      {'time': '5 PM', 'icon': Icons.wb_sunny, 'temp': '71°'},
      {'time': '6 PM', 'icon': Icons.cloud, 'temp': '68°'},
      {'time': '7 PM', 'icon': Icons.grain, 'temp': '66°'},
    ];

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
          itemCount: hourlyData.length,
          itemBuilder: (context, index) {
            final item = hourlyData[index];

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
                  Text(item['time'], style: Styles.textStyle14),
                  Icon(item['icon'], color: AppColors.primaryText, size: 26),
                  Text(
                    item['temp'],
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
