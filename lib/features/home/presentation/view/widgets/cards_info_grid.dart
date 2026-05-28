import 'package:climate/features/home/data/models/weather_model.dart';
import 'package:climate/features/home/presentation/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class CardsInfoGrid extends StatelessWidget {
  final WeatherModel weather;

  const CardsInfoGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final current = weather.hourly.first;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          InfoCard(
            title: "UV Index",
            subtitle:
                '${current.uvIndex.toStringAsFixed(1)} • ${current.uvLabel}',
            icon: const Icon(Icons.wb_sunny, color: Colors.white),
          ),
          InfoCard(
            title: "Humidity",
            subtitle: '${current.humidity.round()}%',
            icon: const Icon(Icons.water_drop, color: Colors.lightBlueAccent),
          ),
          InfoCard(
            title: "Wind Speed",
            subtitle: '${weather.currentWindSpeed.round()} km/h',
            icon: const Icon(Icons.air, color: Colors.white),
          ),
          InfoCard(
            title: "Wind Direction",
            subtitle: '${weather.currentWindDirection.round()}°',
            icon: const Icon(Icons.navigation, color: Colors.white),
          ),
          InfoCard(
            title: "Temperature",
            subtitle: '${current.temperature.round()}°C',
            icon: const Icon(Icons.thermostat, color: Colors.orange),
          ),
          InfoCard(
            title: "Wind (Hourly)",
            subtitle: '${current.windSpeed.round()} km/h',
            icon: const Icon(Icons.speed, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
