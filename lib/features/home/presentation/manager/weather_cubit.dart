import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:climate/features/home/data/services/weather_service.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  final WeatherService _service = WeatherService();

  Future<void> getWeather() async {
    emit(WeatherLoading());
    try {
      final weather = await _service.fetchWeather();
      emit(WeatherSuccess(weather));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }
}
