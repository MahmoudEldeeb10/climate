import 'package:climate/features/home/data/models/daily_forecast_model.dart';
import 'package:dio/dio.dart';

class DailyForecastService {
  final Dio _dio = Dio();

  Future<List<DailyForecastModel>> getDailyForecast() async {
    final response = await _dio.get(
      'https://hagermaher-forcasting.hf.space/days_forcasting',
    );

    final List forecasts = response.data['forecast'];
    return forecasts
        .map((item) => DailyForecastModel.fromJson(item))
        .toList();
  }
}