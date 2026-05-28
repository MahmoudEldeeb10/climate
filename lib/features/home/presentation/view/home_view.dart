import 'package:climate/features/home/presentation/view/widgets/current_weather_section.dart';
import 'package:climate/features/home/presentation/view/widgets/daily_forecast_section.dart';
import 'package:climate/features/home/presentation/view/widgets/hourly_forecast_section.dart';
import 'package:climate/features/home/presentation/view/widgets/weather_details_section.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CurrentWeatherSection(),
                const HourlyForecastSection(),
                const DailyForecastSection(),
                const WeatherDetailsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



