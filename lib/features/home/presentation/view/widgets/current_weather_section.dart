import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CurrentWeatherSection extends StatelessWidget {
  const CurrentWeatherSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.location_on_outlined, color: AppColors.primaryText),
            SizedBox(width: 5),
            Text(
              "San Francisco",
              style: TextStyle(color: AppColors.primaryText, fontSize: 20),
            ),
          ],
        ),

        Icon(Icons.cloud, size: 80, color: AppColors.primaryText),
        SizedBox(height: 10),
        Text("72°", style: Styles.textStyle30.copyWith(fontSize: 60)),
        Text(
          "Partly Cloudy",
          style: TextStyle(fontSize: 18, color: AppColors.primaryText),
        ),
      ],
    );
  }
}
