import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/features/home/presentation/manager/days_forecast_cubit/days_forecast_cubit.dart';
import 'package:climate/features/home/presentation/manager/days_forecast_cubit/days_forecast_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyForecastSection extends StatelessWidget {
  const DailyForecastSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DaysForecastCubit()..getDailyForecast(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5-Day Forecast',
              style: Styles.textStyle22.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            BlocBuilder<DaysForecastCubit, DaysForecastState>(
              builder: (context, state) {
                if (state is DaysForecastLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DaysForecastFailure) {
                  return Center(
                    child: Text(state.errMessage, style: Styles.textStyle16),
                  );
                }
                if (state is DaysForecastSuccess) {
                  return Column(
                    children: state.forecasts.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.day.substring(0, 3),
                              style: Styles.textStyle16,
                            ),
                            Text(
                              item.date,
                              style: Styles.textStyle16.copyWith(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${item.temp.round()}°',
                              style: Styles.textStyle16,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
