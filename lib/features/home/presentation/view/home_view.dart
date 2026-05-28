import 'package:climate/features/home/presentation/manager/weather_cubit.dart';
import 'package:climate/features/home/presentation/manager/weather_state.dart';
import 'package:climate/features/home/presentation/view/widgets/cards_info_grid.dart';
import 'package:climate/features/home/presentation/view/widgets/current_weather_section.dart';
import 'package:climate/features/home/presentation/view/widgets/daily_forecast_section.dart';
import 'package:climate/features/home/presentation/view/widgets/hourly_forecast_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit()..getWeather(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.chat_outlined, color: Colors.white, size: 28),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (state is WeatherFailure) {
                return Center(
                  child: Text(
                    state.errMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (state is WeatherSuccess) {
                final w = state.weather;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurrentWeatherSection(weather: w),
                        HourlyForecastSection(hourly: w.hourly),
                        DailyForecastSection(daily: w.daily),
                        CardsInfoGrid(weather: w),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
