import 'package:climate/features/home/data/services/daily_forecast_service.dart';
import 'package:climate/features/home/presentation/manager/days_forecast_cubit/days_forecast_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaysForecastCubit extends Cubit<DaysForecastState> {
  DaysForecastCubit() : super(DaysForecastInitial());

  final DailyForecastService _service = DailyForecastService();

  Future<void> getDailyForecast() async {
    if (!isClosed) {
      emit(DaysForecastLoading());
    }

    try {
      final data = await _service.getDailyForecast();

      if (!isClosed) {
        emit(DaysForecastSuccess(data));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DaysForecastFailure(e.toString()));
      }
    }
  }
}
